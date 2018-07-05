<?php
/**
 * (The MIT License)
 *
 * Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * 'Software'), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

use Phalcon\Tag as Tag;

class SessionController extends ControllerBase
{
    public function initialize()
    {
        $this->view->setTemplateAfter('main');
        Tag::setTitle('Sign Up/Sign In');
        parent::initialize();
    }

    public function indexAction()
    {
        if (!$this->request->isPost()) {
            $user_count = Users::find();
            if (count($user_count)) {
                Tag::setDefault('email', '');
                Tag::setDefault('password', '');
            } else {
                $this->flash->success('This is first setup. Please login with user: "admin", password: "ngslims"');
                Tag::setDefault('email', 'admin');
                Tag::setDefault('password', 'ngslims');
            }
        }
    }

    public function registerAction()
    {
        $request = $this->request;
        if ($request->isPost()) {

            $firstname = $request->getPost('firstname', array('string', 'striptags'));
            $lastname = $request->getPost('lastname', array('string', 'striptags'));
            $username = $request->getPost('username', 'alphanum');
            $email = $request->getPost('email', 'email');
            $password = $request->getPost('password');
            $repeatPassword = $this->request->getPost('repeatPassword');

            if ($password != $repeatPassword) {
                $this->flash->error('Passwords are different');
                return false;
            }

            $user = new Users();
            $user->username = $username;
            //$user->password = sha1($password);
            $user->password = $this->security->hash($password);
            $user->firstname = $firstname;
            $user->lastname = $lastname;
            $user->email = $email;
            $user->created_at = new Phalcon\Db\RawValue('now()');
            $user->active = 'Y';
            if ($user->save() == false) {
                foreach ($user->getMessages() as $message) {
                    $this->flash->error((string)$message);
                }
            } else {
                Tag::setDefault('email', '');
                Tag::setDefault('password', '');
                $this->flash->success('Thanks for sign-up, please log-in to start to use ngsLIMS');
                return $this->forward('session/index');
            }
        }
    }

    /**
     * Register authenticated user into session data
     *
     * @param Users $user
     */
    private function _registerSession($user)
    {
        $this->session->set('auth', array(
            'id' => $user->id,
            'firstname' => $user->firstname,
            'lastname' => $user->lastname
        ));
    }

    /**
     * This actions receive the input from the login form
     */
    public function startAction()
    {
        if ($this->request->isPost()) {

            $user_count = Users::find();
            if (!count($user_count)) {

                $user = new Users();
                $user->username = 'admin';
                $user->password = $this->security->hash('ngslims');
                $user->firstname = 'admin';
                $user->lastname = 'ngslims';
                $user->email = 'ngslims_admin@example.com';
                $user->created_at = new Phalcon\Db\RawValue('now()');
                $user->active = 'Y';

                $labUsers = array();
                $labUsers[0] = new LabUsers();
                $labUsers[0]->lab_id = '1'; //Genome Science

                $user->LabUsers = $labUsers;

                if ($user->save() == false) {
                    foreach ($user->getMessages() as $message) {
                        $this->flash->error((string)$message);
                    }
                } else {
                    $this->flash->error('This is first set up. Password is set with "ngslims". Please update admin password.');

                    $this->_registerSession($user);
                    $this->view->setVar('login', is_array($this->session->get('auth')));
                    return $this->forward('index');
                }
            }

            if ($this->security->checkToken()) {
                $email = $this->request->getPost('email', 'email');
                $password = $this->request->getPost('password');
                $user = Users::findFirst("email='$email' AND active='Y'");
                if ($user != false) {
                    if ($this->security->checkHash($password, $user->password)) {
                        $this->_registerSession($user);
                        $this->flash->success('Welcome ' . $user->firstname . ' ' . $user->lastname);

                        $this->view->setVar('login', is_array($this->session->get('auth')));
                        return $this->forward('index');
                    }
                }

                $username = $this->request->getPost('email', 'alphanum');
                $user = Users::findFirst("username='$username' AND active='Y'");
                if ($user != false) {
                    if ($this->security->checkHash($password, $user->password)) {
                        $this->_registerSession($user);
                        $this->flash->success('Welcome ' . $user->firstname . ' ' . $user->lastname);

                        $this->view->setVar('login', is_array($this->session->get('auth')));
                        return $this->forward('index');
                    }
                }

                $this->flash->error('Wrong email/password ');
            }
        }

        return $this->forward('session/index');
    }

    /**
     * Finishes the active session redirecting to the index
     *
     * @return unknown
     */
    public function endAction()
    {
        $this->session->remove('auth');
        $this->flash->success('Goodbye!');
        return $this->forward('index/index');
    }

    /**
     * Account setting form
     */
    public function accountAction()
    {
        $request = $this->request;
        //Get session info
        $auth = $this->session->get('auth');

        //Query the active user
        $user = Users::findFirst($auth['id']);

        if ($user == false) {
            $this->_forward('index/index');
        }

        if (!$request->isPost()) {
            Tag::setDefault('firstname', $user->firstname);
            Tag::setDefault('lastname', $user->lastname);
            Tag::setDefault('email', $user->email);
        } else {

            $firstname = $request->getPost('firstname', array('string', 'striptags'));
            $lastname = $request->getPost('lastname', array('string', 'striptags'));
            $email = $request->getPost('email', 'email');

            $firstname = strip_tags($firstname);
            $lastname = strip_tags($lastname);

            $user->firstname = $firstname;
            $user->lastname = $lastname;
            $user->email = $email;
            $user->active = 'Y';
            if ($user->save() == false) {
                foreach ($user->getMessages() as $message) {
                    $this->flash->error((string)$message);
                }
            } else {
                $this->flash->success('Your profile information was updated successfully');
            }
        }
    }

    /**
     * Password setting form
     */
    public function passwordAction()
    {
        $request = $this->request;
        //Get session info
        $auth = $this->session->get('auth');

        //Query the active user
        $user = Users::findFirst($auth['id']);

        if ($request->isPost()) {

            $newPassword = $request->getPost('newPassword');
            $repeatPassword = $this->request->getPost('repeatPassword');

            if ($this->security->checkHash($newPassword, $user->password)) {
                $this->flash->error('The password does not change');
                return false;
            };

            if ($newPassword != $repeatPassword) {
                $this->flash->error('Passwords are different');
                return false;
            }

            $user->password = $this->security->hash($newPassword);
            if ($user->save() == false) {
                foreach ($user->getMessages() as $message) {
                    $this->flash->error((string)$message);
                }
            } else {
                $this->flash->success('Your password was updated successfully');
            }
        }
    }
}
