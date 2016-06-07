<?php
use Phalcon\Tag, Phalcon\Acl;

class SettingController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateAfter('main');
        Tag::setTitle('Setting');
        parent::initialize();
    }

    public function indexAction()
    {
    }

    public function usersAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                //Custom Filter for username value.
                $filter = new \Phalcon\Filter();
                $filter->add('username', function ($value) {
                    $value = preg_replace('/[^a-zA-Z0-9\.\-_]/', '', $value);
                    $value = preg_replace('/\.+/', '.', $value);
                    $value = preg_replace('/\.+$/', '', $value);
                    return $value;
                });

                $user_id = $this->request->getPost('user_id', 'int');
                $lab_id_array = $this->request->getPost('lab_id_array', array('striptags'));
                $username = $this->request->getPost('username', array('striptags'));
                $username = $filter->sanitize($username, 'username');
                $firstname = $this->request->getPost('firstname', array('striptags', 'trim'));
                $lastname = $this->request->getPost('lastname', array('striptags', 'trim'));
                $email = $this->request->getPost('email', array('email', 'trim'));
                $active = ($this->request->getPost('active', array('striptags'))) ? $this->request->getPost('active', array('striptags')) : null;

                $password_reset = ($this->request->getPost('password_reset', array('striptags'))) ? $this->request->getPost('password_reset', array('striptags')) : null;

                if (empty($user_id)) {
                    $this->flashSession->error('ERROR: Undefined user_id value ' . $user_id . '.');
                }


                if ($user_id > 0) {
                    $user = Users::findFirst("id = $user_id");
                    if (!$user) {
                        $this->flashSession->error('ERROR: Could not get user data values.');
                    }
                    if (empty($username) and $active == 'N') {
                        $user->delete(); //Should be soft-delete (active=N);
                    } else {
                        $user->username = $username;
                        $user->firstname = $firstname;
                        $user->lastname = $lastname;
                        $user->email = $email;
                        $user->active = $active;
                    }
                } else {
                    $user = new Users();
                    $user->username = $username;
                    $user->firstname = $firstname;
                    $user->lastname = $lastname;
                    $user->email = $email;
                    $user->active = $active;
                }

                //Reset password.
                if ($password_reset == 'on') {
                    $temp_password = $this->elements->random();
                    $user->password = $this->security->hash($temp_password);
                }

                /*
 * Check and insert/update/delete lab_users
 */
                $labs = Labs::find("active = 'Y'");
                $lab_users_update = 0;
                $lab_users = array();
                $i = 0;
                foreach ($labs as $lab) {
                    $lab_id = $lab->id;
                    $lab_users_tmp = LabUsers::find(
                        "lab_id = $lab_id AND user_id = $user_id"
                    );
                    $checked_lab_users = in_array($lab_id, $lab_id_array);
                    if (!count($lab_users_tmp) and $checked_lab_users) {
                        $lab_users[$i] = new LabUsers();
                        $lab_users[$i]->lab_id = $lab_id;
                        $lab_users[$i]->user_id = $user_id;
                        $i++;
                        $lab_users_update++;
                    } elseif (count($lab_users_tmp) and !$checked_lab_users) {
                        if ($lab_users_tmp->delete() == false) {
                            foreach ($lab_users_tmp->getMessages() as $message) {
                                $this->flashSession->error((string)$message);
                            }
                        } else {
                            $lab_users_update++;
                        }
                    }
                }

                if ($lab_users_update) {
                    $this->flashSession->success('User：' . $user->getFullname() . ' laboratory record is changed.');
                }

                /*
                 * Save user data values.
                 */
                $user->LabUsers = $lab_users;
                if ($user->save() == false) {
                    foreach ($user->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($user_id == -1) {
                        $this->flashSession->success('User：' . $user->getFullname() . ' is created.');
                    } elseif ($user->active == 'N') {
                        $this->flashSession->success('User：' . $user->getFullname() . ' is change to in-active account.');
                    } else {
                        $this->flashSession->success('User：' . $user->getFullname() . ' record is changed.');
                    }

                }


            }
        } else {
            Tag::appendTitle(' | Users');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $users = $this->modelsManager->createBuilder()
                ->columns(array(
                    'u.*',
                    'GROUP_CONCAT(DISTINCT(l.name)) AS lab_names',
                    'GROUP_CONCAT(DISTINCT(l.id)) AS lab_ids',
                    'COUNT(DISTINCT p.id) AS project_count'
                ))
                ->addFrom('Users', 'u')
                ->leftJoin('LabUsers', 'lu.user_id = u.id', 'lu')
                ->leftJoin('Labs', 'l.id = lu.lab_id', 'l')
                ->leftJoin('Projects', 'p.pi_user_id = u.id', 'p')
                ->groupBy(array('u.id', 'l.id'))
                ->orderBy(array('u.id', 'l.id'))
                ->getQuery()
                ->execute();

            $this->view->setVar('users', $users);

        }
    }

    public function createLabsCheckFieldAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();
                $user_id = $this->request->getPost('user_id', 'int');
                if (empty($user_id)) {
                    $this->flashSession->error('ERROR: Undefined user_id value ' . $user_id . '.');
                }

                $labs = Labs::find("active = 'Y'");
                foreach ($labs as $lab) {
                    $lab_users = LabUsers::find(array(
                        "lab_id = $lab->id AND user_id = $user_id"
                    ));
                    echo "<label class='checkbox'>";
                    if (count($lab_users)) {
                        echo Phalcon\Tag::checkField(array("checkbox-lab_id-" . $lab->id, "value" => $lab->id, 'checked' => ''));
                    } else {
                        echo Phalcon\Tag::checkField(array("checkbox-lab_id-" . $lab->id, "value" => $lab->id));
                    }
                    echo $lab->name;
                    echo '</label>';
                }
            }
        }
    }

    public
    function labsAction()
    {
        Tag::appendTitle(' | Labs');
    }

    public
    function projectsAction()
    {
        Tag::appendTitle(' | Projects');
    }

    public
    function protocolsAction()
    {
        Tag::appendTitle(' | Protocols');
    }

    public
    function instrumentsAction()
    {
        Tag::appendTitle(' | Instruments');
    }

    public
    function oligobarcodesAction()
    {
        Tag::appendTitle(' | Oligobarcodes');
    }

    public
    function organismsAction()
    {
        Tag::appendTitle(' | Organisms');
    }

    public
    function sampleLocationsAction()
    {
        Tag::appendTitle(' | Sample Locations');
    }

    public
    function samplePropertyTypesAction()
    {
        Tag::appendTitle(' | Sample Property Types');
    }

    public
    function stepsAction()
    {
        Tag::appendTitle(' | Steps');
    }

}