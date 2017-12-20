<?php

use Phalcon\Tag, Phalcon\Acl, Phalcon\Filter;

//Custom Filter for name value.
$filter = new Filter();
$filter->add('name_filter', function ($value) {
    $value = preg_replace('/[^a-zA-Z0-9\.\-_]/', '', $value);
    $value = preg_replace('/\.+/', '.', $value);
    $value = preg_replace('/\.+$/', '', $value);
    return $value;
});

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

                $user_id = $request->getPost('user_id', 'int');
                $lab_id_array = $request->getPost('lab_id_array', array('striptags'));
                $username = $request->getPost('username', array('striptags', 'name_filter'));
                $password = $request->getPost('password', array('striptags'));
                $firstname = $request->getPost('firstname', array('striptags', 'trim'));
                $lastname = $request->getPost('lastname', array('striptags', 'trim'));
                $email = $request->getPost('email', array('email', 'trim'));
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                $password_reset = ($request->getPost('password_reset', array('striptags'))) ? $request->getPost('password_reset', array('striptags')) : null;

                if (empty($user_id)) {
                    return $this->flashSession->error('ERROR: Undefined user_id value ' . $user_id . '.');
                }

                echo "username: $username\n";

                if ($user_id > 0) {
                    $user = Users::findFirst("id = $user_id");
                    if (!$user) {
                        return $this->flashSession->error('ERROR: Could not get user data values.');
                    }
                    if (empty($username) and $active == 'N') { //Case empty($username) via userRemove JavaScript function.
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
                if ($password) {
                    $user->password = $this->security->hash($password);
                } elseif ($password_reset == 'on') {
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
                    } elseif (count($lab_users_tmp) and !$checked_lab_users and !empty($username)) { //Case empty($username) via userRemove JavaScript function.
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
                    $this->flashSession->success('User: ' . $user->getFullname() . ' record is changed.');
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
                        $this->flashSession->success('User: ' . $user->getFullname() . ' is created.');
                    } elseif ($user->active == 'N') {
                        $this->flashSession->success('User: ' . $user->getFullname() . ' is change to in-active account.');
                    } else {
                        $this->flashSession->success('User: ' . $user->getFullname() . ' record is changed.');
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
                ->groupBy(array('u.id'))
                ->orderBy(array('u.id'))
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
                $user_id = $request->getPost('user_id', 'int');
                if (empty($user_id)) {
                    return $this->flashSession->error('ERROR: Undefined user_id value ' . $user_id . '.');
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

    public function labsAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $lab_id = $request->getPost('lab_id', 'int');
                $name = $request->getPost('name', array('striptags', 'trim'));
                $department = ($request->getPost('department', array('striptags'))) ? $request->getPost('department', array('striptags')) : null;
                $zipcode = ($request->getPost('zipcode', array('striptags'))) ? $request->getPost('zipcode', array('striptags')) : null;
                $address1 = ($request->getPost('address1', array('striptags'))) ? $request->getPost('address1', array('striptags')) : null;
                $address2 = ($request->getPost('address2', array('striptags'))) ? $request->getPost('address2', array('striptags')) : null;
                $phone = ($request->getPost('phone', array('striptags'))) ? $request->getPost('phone', array('striptags')) : null;
                $fax = ($request->getPost('fax', array('striptags'))) ? $request->getPost('fax', array('striptags')) : null;
                $email = ($request->getPost('email', array('email', 'trim'))) ? $request->getPost('email', array('email', 'trim')) : null;
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($lab_id)) {
                    return $this->flashSession->error('ERROR: Undefined lab_id value ' . $lab_id . '.');
                }


                if ($lab_id > 0) {
                    $lab = Labs::findFirst("id = $lab_id");
                    if (!$lab) {
                        return $this->flashSession->error('ERROR: Could not get lab data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $lab->delete(); //Should be soft-delete (active=N);
                    } else {
                        $lab->name = $name;
                        $lab->department = $department;
                        $lab->zipcode = $zipcode;
                        $lab->address1 = $address1;
                        $lab->address2 = $address2;
                        $lab->phone = $phone;
                        $lab->fax = $fax;
                        $lab->email = $email;
                        $lab->active = $active;
                    }
                } else {
                    $lab = new Labs();
                    $lab->name = $name;
                    $lab->department = $department;
                    $lab->zipcode = $zipcode;
                    $lab->address1 = $address1;
                    $lab->address2 = $address2;
                    $lab->phone = $phone;
                    $lab->fax = $fax;
                    $lab->email = $email;
                    $lab->active = $active;
                }

                /*
                 * Save user data values.
                 */
                if ($lab->save() == false) {
                    foreach ($lab->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($lab_id == -1) {
                        $this->flashSession->success('Lab.: ' . $lab->name . ' is created.');
                    } elseif ($lab->active == 'N') {
                        $this->flashSession->success('Lab.: ' . $lab->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('Lab.: ' . $lab->name . ' record is changed.');
                    }

                }
            }
        } else {
            Tag::appendTitle(' | Labs');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $labs = Labs::find();
            $this->view->setVar('labs', $labs);
        }
    }

    public function labUsersAction($lab_id)
    {
        $request = $this->request;
        $lab = Labs::findFirst($lab_id);
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $new_users_id_array = $request->getPost('new_users_id_array', array('striptags'));
                $del_users_id_array = $request->getPost('del_users_id_array', array('striptags'));

                $labUsers = array();
                $i = 0;
                $new_users_name = array();
                $del_users_name = array();
                if (count($new_users_id_array)) {
                    foreach ($new_users_id_array as $user_id) {
                        $labUsers[$i] = new LabUsers();
                        $labUsers[$i]->lab_id = $lab->id;
                        $labUsers[$i]->user_id = $user_id;
                        $new_users_name[] = Users::findFirst($user_id)->getFullname();
                        $i++;
                    }
                }
                if (count($del_users_id_array)) {
                    foreach ($del_users_id_array as $user_id) {
                        $labUsers[$i] = LabUsers::find("user_id = $user_id AND lab_id = $lab_id");
                        $labUsers[$i]->delete();
                        $del_users_name[] = Users::findFirst($user_id)->getFullname();
                        $i++;
                    }
                }

                if ($i > 0) {
                    /*
                     * Save LabUser data values.
                     */
                    $lab->LabUsers = $labUsers;
                    if ($lab->save() == false) {
                        foreach ($lab->getMessages() as $message) {
                            $this->flashSession->error((string)$message);
                        }
                        return false;
                    } else {
                        if (count($new_users_name)) {
                            $new_users_name_str = implode(",", $new_users_name);
                            $this->flashSession->success('Lab. Users: ' . $new_users_name_str . ' is added.');
                        }
                        if (count($del_users_name)) {
                            $del_users_name_str = implode(",", $del_users_name);
                            $this->flashSession->success('Lab. Users: ' . $del_users_name_str . ' is deleted.');
                        }

                    }
                }
            }
        } else {
            Tag::appendTitle(' | ' . $lab->name . ' | Lab. Members');
            $this->view->setVar('lab', $lab);

            $lab_users = $lab->LabUsers;
            $lab_user_id = array();
            foreach ($lab_users as $user) {
                $lab_user_id[] = $user->user_id;
            }
            /*
             * Create candidate user list whom not be joined Lab. (!=$lab_id)
             */
            $users_candidate_tmp = $this->modelsManager->createBuilder()
                ->columns(array(
                    'u.*'
                ))
                ->addFrom('Users', 'u');

            if (count($lab_user_id)) {
                $users_candidate_tmp = $users_candidate_tmp
                    ->notInWhere('u.id', $lab_user_id);
            }

            $users_candidate = $users_candidate_tmp
                ->andWhere('u.active = "Y"')
                ->groupBy('u.id')
                ->orderBy('u.lastname ASC, u.firstname ASC')
                ->getQuery()
                ->execute();
            $this->view->setVar('users_candidate', $users_candidate);
        }

    }

    public function projectsAction()
    {
        $request = $this->request;
        $auth = $this->session->get('auth');
        $my_user = Users::findFirst($auth['id']);
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $project_id = $request->getPost('project_id', 'int');
                $lab_id = $request->getPost('lab_id', 'int');
                $name = $request->getPost('name', array('striptags', 'trim', 'name_filter'));
                $pi_user_id = $request->getPost('pi_user_id', 'int');
                $project_type_id = $request->getPost('project_type_id', 'int');
                $description = ($request->getPost('description', array('striptags'))) ? $request->getPost('description', array('striptags')) : null;
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($project_id)) {
                    return $this->flashSession->error('ERROR: Undefined project_id value ' . $project_id . '.');
                }


                if ($project_id > 0) {
                    $project = Projects::findFirst("id = $project_id");
                    if (!$project) {
                        return $this->flashSession->error('ERROR: Could not get project data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $project->delete(); //Should be soft-delete (active=N);
                    } else {
                        $project->lab_id = $lab_id;
                        $project->name = $name;
                        $project->pi_user_id = $pi_user_id;
                        $project->project_type_id = $project_type_id;
                        $project->description = $description;
                        $project->active = $active;
                    }
                } else {
                    $project = new Projects();
                    $project->lab_id = $lab_id;
                    $project->name = $name;
                    $project->user_id = $my_user->id;
                    $project->pi_user_id = $pi_user_id;
                    $project->project_type_id = $project_type_id;
                    $project->description = $description;
                    $project->active = $active;
                }

                /*
                 * Save project data values.
                 */
                //var_dump($project->toArray());
                if ($project->save() == false) {
                    foreach ($project->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($project_id == -1) {
                        $this->flashSession->success('Project: ' . $project->name . ' is created.');
                    } elseif ($project->active == 'N') {
                        $this->flashSession->success('Project: ' . $project->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('Project: ' . $project->name . ' record is changed.');
                    }

                }

            }
        } else {
            Tag::appendTitle(' | Projects');

            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $projects = Projects::find();
            $labs = Labs::find("active = 'Y'");
            $project_types = ProjectTypes::find("active = 'Y'");

            $this->view->setVar('projects', $projects);
            $this->view->setVar('labs', $labs);
            $this->view->setVar('project_types', $project_types);

            $this->view->setVar('my_user', $my_user);

        }
    }

    public function projectTypesAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $project_type_id = $request->getPost('project_type_id', 'int');
                $name = $request->getPost('name', array('striptags', 'trim', 'name_filter'));
                $description = ($request->getPost('description', array('striptags'))) ? $request->getPost('description', array('striptags')) : null;
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($project_type_id)) {
                    return $this->flashSession->error('ERROR: Undefined project_type_id value ' . $project_type_id . '.');
                }


                if ($project_type_id >= -1) { //Project Type ID has -1 as "Undefined" project types.
                    $project_type = ProjectTypes::findFirst("id = $project_type_id");
                    if (!$project_type) {
                        return $this->flashSession->error('ERROR: Could not get project_type data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $project_type->delete(); //Should be soft-delete (active=N);
                    } else {
                        $project_type->name = $name;
                        $project_type->description = $description;
                        $project_type->active = $active;
                    }
                } else {
                    $project_type = new ProjectTypes();
                    $project_type->name = $name;
                    $project_type->description = $description;
                    $project_type->active = $active;
                }

                /*
                 * Save project_type data values.
                 */
                //var_dump($project_type->toArray());
                if ($project_type->save() == false) {
                    foreach ($project_type->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($project_type_id == -100) {
                        $this->flashSession->success('ProjectType: ' . $project_type->name . ' is created.');
                    } elseif ($project_type->active == 'N') {
                        $this->flashSession->success('ProjectType: ' . $project_type->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('ProjectType: ' . $project_type->name . ' record is changed.');
                    }

                }

            }
        } else {
            Tag::appendTitle(' | Project Types');

            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $project_types = ProjectTypes::find();

            $this->view->setVar('project_types', $project_types);

        }
    }

    public function createPiUsersSelectAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();
                $lab_id = $request->getPost('lab_id', 'int');
                $pi_user_id = $request->getPost('pi_user_id', 'int');
                if (empty($lab_id)) {
                    $this->flashSession->error('ERROR: Undefined lab_id value ' . $lab_id . '.');
                }

                $lab_users = $this->modelsManager->createBuilder()
                    ->addFrom('Users', 'u')
                    ->join('LabUsers', 'lu.user_id = u.id', 'lu')
                    ->where('lu.lab_id = :lab_id:', array("lab_id" => $lab_id))
                    ->andWhere('u.active = "Y"')
                    ->orderBy('u.lastname ASC, u.firstname ASC')
                    ->getQuery()
                    ->execute();

                // @TODO could not use Phalcon/Tag function in this case with using u.getFullname()
                echo '<select id="modal-pi_user_id" class="form-control">';
                if ($pi_user_id == 0) {
                    echo '<option value="0">Please select PI...</option>';
                }
                foreach ($lab_users as $lab_user) {
                    if ($lab_user->id == $pi_user_id) {
                        echo '<option value="' . $lab_user->id . '" selected>' . $lab_user->getFullname() . '</option>';
                    } else {
                        echo '<option value="' . $lab_user->id . '">' . $lab_user->getFullname() . '</option>';
                    }
                }
                echo '</select>';
            }
        }
    }

    public function projectUsersAction($project_id)
    {
        $request = $this->request;
        $project = Projects::findFirst($project_id);
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $new_users_id_array = $request->getPost('new_users_id_array', array('striptags'));
                $del_users_id_array = $request->getPost('del_users_id_array', array('striptags'));

                $projectUsers = array();
                $i = 0;
                $new_users_name = array();
                $del_users_name = array();
                if (count($new_users_id_array)) {
                    foreach ($new_users_id_array as $user_id_str) {
                        $user_id_array = explode('-', $user_id_str); // $user_id_str is <lab_id>-<user_id>
                        $projectUsers[$i] = new ProjectUsers();
                        $projectUsers[$i]->project_id = $project_id;
                        $projectUsers[$i]->user_id = $user_id_array[0];
                        $new_users_name[] = Users::findFirst($user_id_array[0])->getFullname();
                        $i++;
                    }
                }
                if (count($del_users_id_array)) {
                    foreach ($del_users_id_array as $user_id_str) {
                        $user_id_array = explode('-', $user_id_str); // $user_id_str is <lab_id>-<user_id>
                        $projectUsers[$i] = ProjectUsers::find("project_id = $project_id AND user_id = $user_id_array[0]");
                        $projectUsers[$i]->delete();
                        $del_users_name[] = Users::findFirst($user_id_array[0])->getFullname();
                        $i++;
                    }
                }

                if ($i > 0) {
                    /*
                     * Save ProjectUsers data values.
                     */
                    $project->ProjectUsers = $projectUsers;
                    if ($project->save() == false) {
                        foreach ($project->getMessages() as $message) {
                            $this->flashSession->error((string)$message);
                        }
                        return false;
                    } else {
                        if (count($new_users_name)) {
                            $new_users_name_str = implode(",", $new_users_name);
                            $this->flashSession->success('Project Users: ' . $new_users_name_str . ' is added.');
                        }
                        if (count($del_users_name)) {
                            $del_users_name_str = implode(",", $del_users_name);
                            $this->flashSession->success('Project Users: ' . $del_users_name_str . ' is deleted.');
                        }

                    }
                }
            }
        } else {
            Tag::appendTitle(' | ' . $project->name . ' | Lab. Members');
            $this->view->setVar('project', $project);

            $project_users = $project->ProjectUsers;
            $this->view->setVar('project_users', $project_users);

            $project_user_id = array();
            foreach ($project_users as $user) {
                $lab_user_id[] = $user->user_id;
            }
            /*
             * Create candidate user list whom not be joined Project (!=$project_id)
             */
            $users_candidate_tmp = $this->modelsManager->createBuilder()
                ->columns(array(
                    'u.*'
                ))
                ->addFrom('Users', 'u');

            if (count($project_user_id)) {
                $users_candidate_tmp = $users_candidate_tmp
                    ->notInWhere('u.id', $project_user_id);
            }

            $users_candidate = $users_candidate_tmp
                ->andWhere('u.active = "Y"')
                ->groupBy('u.id')
                ->orderBy('u.lastname ASC, u.firstname ASC')
                ->getQuery()
                ->execute();
            $this->view->setVar('users_candidate', $users_candidate);

        }

    }

    public function stepsAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $step_id = $request->getPost('step_id', 'int');
                $name = $request->getPost('name', array('striptags', 'trim'));
                $short_name = $request->getPost('short_name', array('striptags', 'name_filter'));
                $step_phase_code = $request->getPost('step_phase_code', array('striptags', 'alphanum', 'trim', 'upper'));
                $seq_runmode_type_id = ($request->getPost('seq_runmode_type_id', 'int')) ? $request->getPost('seq_runmode_type_id', 'int') : null;
                $platform_code = ($request->getPost('platform_code', array('striptags', 'alphanum', 'trim', 'upper'))) ? $request->getPost('platform_code', array('striptags', 'alphanum', 'trim', 'upper')) : null;
                $nucleotide_type = $request->getPost('nucleotide_type', array('striptags', 'alphanum', 'trim', 'upper'));
                $sort_order = $request->getPost('sort_order', 'int');
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($step_id)) {
                    return $this->flashSession->error('ERROR: Undefined step_id value ' . $step_id . '.');
                }


                if ($step_id > 0) {
                    $step = Steps::findFirst("id = $step_id");
                    if (!$step) {
                        return $this->flashSession->error('ERROR: Could not get step data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $step->delete(); //Should be soft-delete (active=N);
                    } else {
                        $step->name = $name;
                        $step->short_name = $short_name;
                        $step->step_phase_code = $step_phase_code;
                        $step->seq_runmode_type_id = $seq_runmode_type_id;
                        $step->platform_code = $platform_code;
                        $step->nucleotide_type = $nucleotide_type;
                        $step->sort_order = $sort_order;
                        $step->active = $active;
                    }
                } else {
                    $step = new Steps();
                    $step->name = $name;
                    $step->short_name = $short_name;
                    $step->step_phase_code = $step_phase_code;
                    $step->seq_runmode_type_id = $seq_runmode_type_id;
                    $step->platform_code = $platform_code;
                    $step->nucleotide_type = $nucleotide_type;
                    $step->sort_order = $sort_order;
                    $step->active = $active;
                }

                /*
                 * Save user data values.
                 */
                if ($step->save() == false) {
                    foreach ($step->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($step_id == -1) {
                        $this->flashSession->success('Project: ' . $step->name . ' is created.');
                    } elseif ($step->active == 'N') {
                        $this->flashSession->success('Project: ' . $step->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('Project: ' . $step->name . ' record is changed.');
                    }

                }

            }
        } else {
            Tag::appendTitle(' | Steps');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $steps = $this->modelsManager->createBuilder()
                ->addFrom('Steps', 's')
                ->join('StepPhases', 'sp.step_phase_code = s.step_phase_code', 'sp')
                ->orderBy('sp.sort_order ASC, s.sort_order ASC')
                ->getQuery()
                ->execute();

            $step_phases = StepPhases::find(array(
                "active = 'Y'",
                "orderBy" => "sort_order ASC"
            ));

            $seq_runmode_types = SeqRunmodeTypes::find(array(
                "active = 'Y'",
                "orderBy" => "sort_order ASC"
            ));

            $platforms = Platforms::find("active = 'Y'");

            $this->view->setVar('steps', $steps);
            $this->view->setVar('step_phases', $step_phases);
            $this->view->setVar('seq_runmode_types', $seq_runmode_types);
            $this->view->setVar('platforms', $platforms);

        }
    }

    public function protocolsAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $protocol_id = $request->getPost('protocol_id', 'int');
                $name = $request->getPost('name', array('striptags', 'name_filter'));
                $description = ($request->getPost('description', array('striptags'))) ? $request->getPost('description', array('striptags')) : null;
                $step_id = $request->getPost('step_id', 'int');
                $min_multiplex_number = $request->getPost('min_multiplex_number', 'int');
                $max_multiplex_number = $request->getPost('max_multiplex_number', 'int');
                $next_step_phase_code = $request->getPost('next_step_phase_code', array('striptags'));
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($protocol_id)) {
                    return $this->flashSession->error('ERROR: Undefined protocol_id value ' . $protocol_id . '.');
                }


                if ($protocol_id > 0) {
                    $protocol = Protocols::findFirst("id = $protocol_id");
                    if (!$protocol) {
                        return $this->flashSession->error('ERROR: Could not get protocol data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $protocol->delete(); //Should be soft-delete (active=N);
                    } else {
                        $protocol->name = $name;
                        $protocol->description = $description;
                        $protocol->step_id = $step_id;
                        $protocol->min_multiplex_number = $min_multiplex_number;
                        $protocol->max_multiplex_number = $max_multiplex_number;
                        $protocol->next_step_phase_code = $next_step_phase_code;
                        $protocol->active = $active;
                    }
                } else {
                    $protocol = new Protocols();
                    $protocol->name = $name;
                    $protocol->description = $description;
                    $protocol->step_id = $step_id;
                    $protocol->min_multiplex_number = $min_multiplex_number;
                    $protocol->max_multiplex_number = $max_multiplex_number;
                    $protocol->next_step_phase_code = $next_step_phase_code;
                    $protocol->active = $active;
                }

                /*
                 * Save protocol data values.
                 */
                //var_dump($protocol->toArray());
                if ($protocol->save() == false) {
                    foreach ($protocol->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($protocol_id == -1) {
                        $this->flashSession->success('Protocol: ' . $protocol->name . ' is created.');
                    } elseif ($protocol->active == 'N') {
                        $this->flashSession->success('Protocol: ' . $protocol->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('Protocol: ' . $protocol->name . ' record is changed.');
                    }

                }

            }
        } else {
            Tag::appendTitle(' | Protocols');

            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $protocols = Protocols::find();
            $step_prep = Steps::find("step_phase_code = 'PREP'");

            $this->view->setVar('protocols', $protocols);
            $this->view->setVar('step_prep', $step_prep);

        }
    }

    public function protocolOligobarcodeSchemeAllowsAction($protocol_id)
    {
        $request = $this->request;
        $protocol = Protocols::findFirst($protocol_id);
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $new_oligobarcode_scheme_id_array = $request->getPost('new_oligobarcode_scheme_id_array', array('striptags'));
                $del_oligobarcode_scheme_id_array = $request->getPost('del_oligobarcode_scheme_id_array', array('striptags'));

                $oligobarcodeSchemeAllows = array();
                $i = 0;
                $new_oligobarcode_scheme_name = array();
                $del_oligobarcode_scheme_name = array();
                $has_oligobarcodeB = ($protocol->next_step_phase_code == 'DUALMULTIPLEX') ? 'Y' : 'N';
                if (count($new_oligobarcode_scheme_id_array)) {
                    foreach ($new_oligobarcode_scheme_id_array as $oligobarcode_scheme_id) {
                        $oligobarcodeSchemeAllows[$i] = new OligobarcodeSchemeAllows();
                        $oligobarcodeSchemeAllows[$i]->oligobarcode_scheme_id = $oligobarcode_scheme_id;
                        $oligobarcodeSchemeAllows[$i]->protocol_id = $protocol_id;
                        $oligobarcodeSchemeAllows[$i]->has_oligobarcodeB = $has_oligobarcodeB;
                        $new_oligobarcode_scheme_name[] = OligobarcodeSchemes::findFirst($oligobarcode_scheme_id);
                        $i++;
                    }
                }
                if (count($del_oligobarcode_scheme_id_array)) {
                    foreach ($del_oligobarcode_scheme_id_array as $oligobarcode_scheme_id) {
                        $oligobarcodeSchemeAllows[$i] = OligobarcodeSchemeAllows::find("protocol_id = $protocol_id AND oligobarcode_scheme_id = $oligobarcode_scheme_id");
                        $oligobarcodeSchemeAllows[$i]->delete();
                        $del_oligobarcode_scheme_name[] = OligobarcodeSchemes::findFirst($oligobarcode_scheme_id);
                        $i++;
                    }
                }

                if ($i > 0) {
                    /*
                     * Save $oligobarcodeSchemeAllows data values.
                     */
                    $protocol->OligobarcodeSchemeAllows = $oligobarcodeSchemeAllows;
                    if ($protocol->save() == false) {
                        foreach ($protocol->getMessages() as $message) {
                            $this->flashSession->error((string)$message);
                        }
                        return false;
                    } else {
                        if (count($new_oligobarcode_scheme_name)) {
                            $new_oligobarcode_scheme_name_str = implode(",", $new_oligobarcode_scheme_name);
                            $this->flashSession->success('Oligobarcode Scheme: ' . $new_oligobarcode_scheme_name_str . ' is added.');
                        }
                        if (count($del_oligobarcode_scheme_name)) {
                            $del_oligobarcode_scheme_name_str = implode(",", $del_oligobarcode_scheme_name);
                            $this->flashSession->success('Oligobarcode Scheme: ' . $del_oligobarcode_scheme_name_str . ' is deleted.');
                        }

                    }
                }
            }
        } else {
            Tag::appendTitle(' | ' . $protocol->name . ' | Oligobarcode Scheme Allows');
            $this->view->setVar('protocol', $protocol);

            $protocol_oligobarcode_scheme_allows = $protocol->OligobarcodeSchemeAllows;
            $this->view->setVar('protocol_oligobarcode_scheme_allows', $protocol_oligobarcode_scheme_allows);

            $oligobarcode_scheme_id = array();
            foreach ($protocol_oligobarcode_scheme_allows as $oligobarcode_scheme_allow) {
                $oligobarcode_scheme_id[] = $oligobarcode_scheme_allow->oligobarcode_scheme_id;
            }
            /*
             * Create candidate OligobarcodeSchemes list whom not be joined OligobarcodeSchemeAllows (!=$oligobarcode_scheme_id)
             */
            $oligobarcode_scheme_candidate_tmp = $this->modelsManager->createBuilder()
                ->addFrom('OligobarcodeSchemes', 'os');

            if (count($oligobarcode_scheme_id)) {
                $oligobarcode_scheme_candidate_tmp = $oligobarcode_scheme_candidate_tmp
                    ->notInWhere('os.id', $oligobarcode_scheme_id);
            }

            if ($protocol->next_step_phase_code != 'DUALMULTIPLEX') {
                $oligobarcode_scheme_candidate_tmp = $oligobarcode_scheme_candidate_tmp
                    ->andWhere('os.is_oligobarcodeB = "N"');
            }

            $oligobarcode_scheme_candidate = $oligobarcode_scheme_candidate_tmp
                ->andWhere('os.active = "Y"')
                ->getQuery()
                ->execute();
            $this->view->setVar('oligobarcode_scheme_candidate', $oligobarcode_scheme_candidate);

        }

    }

    public function oligobarcodeSchemesAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $oligobarcode_scheme_id = $request->getPost('oligobarcode_scheme_id', 'int');
                $name = $request->getPost('name', array('striptags', 'trim'));
                $description = ($request->getPost('description', array('striptags'))) ? $request->getPost('description', array('striptags')) : null;
                $is_oligobarcodeB = $request->getPost('is_oligobarcodeB', array('striptags'));
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($oligobarcode_scheme_id)) {
                    return $this->flashSession->error('ERROR: Undefined oligobarcode_scheme_id value ' . $oligobarcode_scheme_id . '.');
                }


                if ($oligobarcode_scheme_id > 0) {
                    $oligobarcode_scheme = OligobarcodeSchemes::findFirst("id = $oligobarcode_scheme_id");
                    if (!$oligobarcode_scheme) {
                        return $this->flashSession->error('ERROR: Could not get oligobarcode_scheme data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $oligobarcode_scheme->delete(); //Should be soft-delete (active=N);
                    } else {
                        $oligobarcode_scheme->name = $name;
                        $oligobarcode_scheme->description = $description;
                        $oligobarcode_scheme->is_oligobarcodeB = $is_oligobarcodeB;
                        $oligobarcode_scheme->active = $active;
                    }
                } else {
                    $oligobarcode_scheme = new OligobarcodeSchemes();
                    $oligobarcode_scheme->name = $name;
                    $oligobarcode_scheme->description = $description;
                    $oligobarcode_scheme->is_oligobarcodeB = $is_oligobarcodeB;
                    $oligobarcode_scheme->active = $active;
                }

                /*
                 * Save oligobarcode scheme data values.
                 */
                //var_dump($oligobarcode_scheme->toArray());
                if ($oligobarcode_scheme->save() == false) {
                    foreach ($oligobarcode_scheme->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($oligobarcode_scheme_id == -1) {
                        $this->flashSession->success('OligobarcodeScheme: ' . $oligobarcode_scheme->name . ' is created.');
                    } elseif ($oligobarcode_scheme->active == 'N') {
                        $this->flashSession->success('OligobarcodeScheme: ' . $oligobarcode_scheme->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('OligobarcodeScheme: ' . $oligobarcode_scheme->name . ' record is changed.');
                    }

                }

            }
        } else {
            Tag::appendTitle(' | OligobarcodeSchemes');

            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $oligobarcode_schemes = OligobarcodeSchemes::find();

            $this->view->setVar('oligobarcode_schemes', $oligobarcode_schemes);

        }
    }

    public function oligobarcodeSchemeOligobarcodesAction($oligobarcode_scheme_id)
    {
        $request = $this->request;
        $oligobarcode_scheme = OligobarcodeSchemes::findFirst($oligobarcode_scheme_id);
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $new_oligobarcode_id_array = $request->getPost('new_oligobarcode_id_array', array('striptags'));
                $del_oligobarcode_id_array = $request->getPost('del_oligobarcode_id_array', array('striptags'));

                $oligobarcodeSchemeOligobarcodes = array();
                $i = 0;
                $new_oligobarcode_name = array();
                $del_oligobarcode_name = array();
                if (count($new_oligobarcode_id_array)) {
                    foreach ($new_oligobarcode_id_array as $oligobarcode_id) {
                        $oligobarcodeSchemeOligobarcodes[$i] = Oligobarcodes::findFirst($oligobarcode_id);
                        $oligobarcodeSchemeOligobarcodes[$i]->oligobarcode_scheme_id = $oligobarcode_scheme_id;
                        $new_oligobarcode_name[] = $oligobarcodeSchemeOligobarcodes[$i]->name;
                        $i++;
                    }
                }
                if (count($del_oligobarcode_id_array)) {
                    foreach ($del_oligobarcode_id_array as $oligobarcode_id) {
                        $oligobarcode = Oligobarcodes::findFirst($oligobarcode_id);
                        $oligobarcode->oligobarcode_scheme_id = null;
                        if ($oligobarcode->save() == false) {
                            foreach ($oligobarcode->getMessages() as $message) {
                                $this->flashSession->error((string)$message);
                            }
                            return false;
                        }
                        $del_oligobarcode_name[] = $oligobarcodeSchemeOligobarcodes[$i]->name;
                        $i++;
                    }
                }

                if ($i > 0) {
                    /*
                     * Save $oligobarcodeSchemeOligobarcodes data values.
                     */
                    $oligobarcode_scheme->Oligobarcodes = $oligobarcodeSchemeOligobarcodes;
                    if ($oligobarcode_scheme->save() == false) {
                        foreach ($oligobarcode_scheme->getMessages() as $message) {
                            $this->flashSession->error((string)$message);
                        }
                        return false;
                    } else {
                        if (count($new_oligobarcode_name)) {
                            $new_oligobarcode_name_str = implode(",", $new_oligobarcode_name);
                            $this->flashSession->success('Oligobarcode Scheme: ' . $new_oligobarcode_name_str . ' is added.');
                        }
                        if (count($del_oligobarcode_name)) {
                            $del_oligobarcode_name_str = implode(",", $del_oligobarcode_name);
                            $this->flashSession->success('Oligobarcode Scheme: ' . $del_oligobarcode_name_str . ' is deleted.');
                        }

                    }
                }
            }
        } else {
            Tag::appendTitle(' | ' . $oligobarcode_scheme->name . ' | Oligobarcodes');
            $this->view->setVar('oligobarcode_scheme', $oligobarcode_scheme);

            $oligobarcode_scheme_oligobarcodes = $oligobarcode_scheme->Oligobarcodes;
            $this->view->setVar('oligobarcode_scheme_oligobarcodes', $oligobarcode_scheme_oligobarcodes);

            /*
             * Create candidate oligobarcode list whom not has oligobarcode_scheme_id
             */
            $oligobarcodes_candidate = $this->modelsManager->createBuilder()
                ->addFrom('Oligobarcodes', 'o')
                ->where('o.oligobarcode_scheme_id IS NULL')
                ->andWhere('o.active = "Y"')
                ->getQuery()
                ->execute();
            $this->view->setVar('oligobarcodes_candidate', $oligobarcodes_candidate);

        }

    }

    public function oligobarcodesAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                if ($request->hasPost('changes')) {
                    $this->view->disable();
                    $changes = $request->getPost('changes');
                    foreach ($changes as $oligobarcode_id => $rowValues) {

                        $oligobarcode = Oligobarcodes::findFirst($oligobarcode_id);
                        if (!$oligobarcode) {
                            $oligobarcode = new Oligobarcodes();
                        }

                        foreach ($rowValues as $colNameToChange => $valueChangeTo) {

                            if (empty($valueChangeTo)) {
                                $valueChangeTo = null;
                            } elseif ($colNameToChange == "barcode_seq") {
                                $valueChangeTo = strtoupper($valueChangeTo);
                                if (!preg_match('/[AGCTN]/', $valueChangeTo)) {
                                    $this->flashSession->error("Could not use except [AGCTN] string on barcode_seq.");
                                    return;
                                }
                            } elseif ($colNameToChange == "oligobarcode_scheme_id") {
                                $oligobarcode_scheme = OligobarcodeSchemes::findFirstByName($valueChangeTo);
                                $oligobarcode_scheme_id = ($oligobarcode_scheme) ? $oligobarcode_scheme->id : null;
                                $valueChangeTo = $oligobarcode_scheme_id;
                            }

                            $oligobarcode->$colNameToChange = $valueChangeTo;

                        }

                        if (!$oligobarcode->save()) {
                            foreach ($oligobarcode->getMessages() as $message) {
                                $this->flashSession->error((string)$message);
                            }
                            return;
                        }
                    }
                    // Something return is necessary for frontend jQuery Ajax to find success or fail.
                    echo json_encode($changes);
                }
            }
        } else {
            Tag::appendTitle(' | Oligobarcodes');
            $this->assets
                ->addJs('js/handsontable/dist/handsontable.full.min.js')
                ->addJs('js/numeral.min.js')
                ->addCss('js/handsontable/dist/handsontable.full.min.css');
        }
    }

    public function sampleTypesAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $sample_type_id = $request->getPost('sample_type_id', 'int');
                $name = $request->getPost('name', array('striptags', 'trim'));
                $nucleotide_type = $request->getPost('nucleotide_type', array('striptags', 'name_filter', 'upper'));
                $sample_type_code = $request->getPost('sample_type_code', array('striptags', 'name_filter', 'upper'));
                $sort_order = $request->getPost('sort_order', 'int');
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($sample_type_id)) {
                    return $this->flashSession->error('ERROR: Undefined sample_type_id value ' . $sample_type_id . '.');
                }


                if ($sample_type_id > 0) {
                    $sample_type = SampleTypes::findFirst("id = $sample_type_id");
                    if (!$sample_type) {
                        return $this->flashSession->error('ERROR: Could not get sample_type data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $sample_type->delete(); //Should be soft-delete (active=N);
                    } else {
                        $sample_type->name = $name;
                        $sample_type->nucleotide_type = $nucleotide_type;
                        $sample_type->sample_type_code = $sample_type_code;
                        $sample_type->sort_order = $sort_order;
                        $sample_type->active = $active;
                    }
                } else {
                    $sample_type = new SampleTypes();
                    $sample_type->name = $name;
                    $sample_type->nucleotide_type = $nucleotide_type;
                    $sample_type->sample_type_code = $sample_type_code;
                    $sample_type->sort_order = $sort_order;
                    $sample_type->active = $active;
                }

                /*
                 * Save user data values.
                 */
                if ($sample_type->save() == false) {
                    foreach ($sample_type->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($sample_type == -1) {
                        $this->flashSession->success('Sample Type: ' . $sample_type->name . ' is created.');
                    } elseif ($sample_type->active == 'N') {
                        $this->flashSession->success('Sample Type: ' . $sample_type->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('Sample Type: ' . $sample_type->name . ' record is changed.');
                    }

                }

            }
        } else {
            Tag::appendTitle(' | Sample Types');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $sample_types = SampleTypes::find(array(
                "order" => "nucleotide_type ASC, sort_order ASC"
            ));

            $this->view->setVar('sample_types', $sample_types);

        }
    }

    public function samplePropertyTypesAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $sample_property_type_id = $request->getPost('sample_property_type_id', 'int');
                $name = $request->getPost('name', array('striptags', 'trim'));
                $mo_term_name = $request->getPost('mo_term_name', array('striptags', 'name_filter'));
                $mo_id = $request->getPost('mo_id', array('striptags', 'trim'));
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($sample_property_type_id)) {
                    return $this->flashSession->error('ERROR: Undefined sample_property_type_id value ' . $sample_property_type_id . '.');
                }


                if ($sample_property_type_id > 0) {
                    $sample_property_type = SamplePropertyTypes::findFirst("id = $sample_property_type_id");
                    if (!$sample_property_type) {
                        return $this->flashSession->error('ERROR: Could not get sample_property_type data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $sample_property_type->delete(); //Should be soft-delete (active=N);
                    } else {
                        $sample_property_type->name = $name;
                        $sample_property_type->mo_term_name = $mo_term_name;
                        $sample_property_type->mo_id = $mo_id;
                        $sample_property_type->active = $active;
                    }
                } else {
                    $sample_property_type = new SamplePropertyTypes();
                    $sample_property_type->name = $name;
                    $sample_property_type->mo_term_name = $mo_term_name;
                    $sample_property_type->mo_id = $mo_id;
                    $sample_property_type->active = $active;
                }

                /*
                 * Save user data values.
                 */
                if ($sample_property_type->save() == false) {
                    foreach ($sample_property_type->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($sample_property_type == -1) {
                        $this->flashSession->success('Sample Property Type: ' . $sample_property_type->name . ' is created.');
                    } elseif ($sample_property_type->active == 'N') {
                        $this->flashSession->success('Sample Property Type: ' . $sample_property_type->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('Sample Property Type: ' . $sample_property_type->name . ' record is changed.');
                    }

                }

            }
        } else {
            Tag::appendTitle(' | Sample Property Types');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $sample_property_types = SamplePropertyTypes::find();

            $this->view->setVar('sample_property_types', $sample_property_types);

        }
    }

    public function sampleLocationsAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $sample_location_id = $request->getPost('sample_location_id', 'int');
                $name = $request->getPost('name', array('striptags', 'name_filter'));
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($sample_location_id)) {
                    return $this->flashSession->error('ERROR: Undefined $sample_location_id value ' . $sample_location_id . '.');
                }


                if ($sample_location_id > 0) {
                    $sample_location = SampleLocations::findFirst("id = $sample_location_id");
                    if (!$sample_location) {
                        return $this->flashSession->error('ERROR: Could not get $sample_location data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $sample_location->delete(); //Should be soft-delete (active=N);
                    } else {
                        $sample_location->name = $name;
                        $sample_location->active = $active;
                    }
                } else {
                    $sample_location = new SampleLocations();
                    $sample_location->name = $name;
                    $sample_location->active = $active;
                }

                /*
                 * Save user data values.
                 */
                if ($sample_location->save() == false) {
                    foreach ($sample_location->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($sample_location == -1) {
                        $this->flashSession->success('Sample Location: ' . $sample_location->name . ' is created.');
                    } elseif ($sample_location->active == 'N') {
                        $this->flashSession->success('Sample Location: ' . $sample_location->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('Sample Location: ' . $sample_location->name . ' record is changed.');
                    }

                }

            }
        } else {
            Tag::appendTitle(' | Sample Locations');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $sample_locations = SampleLocations::find();

            $this->view->setVar('sample_locations', $sample_locations);

        }
    }


    public function organismsAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $organism_id = $request->getPost('organism_id', 'int');
                $name = $request->getPost('name', array('striptags', 'trim'));
                $taxonomy_id = $request->getPost('taxonomy_id', 'int');
                $taxonomy = $request->getPost('taxonomy', array('striptags', 'trim'));
                $sort_order = ($request->getPost('sort_order', 'int')) ? $request->getPost('sort_order', 'int') : null;
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($organism_id)) {
                    return $this->flashSession->error('ERROR: Undefined $organism_id value ' . $organism_id . '.');
                }

                if (!empty($name) and count(Organisms::find("taxonomy_id = $taxonomy_id AND id != $organism_id"))) {
                    return $this->flashSession->error('ERROR: taxonomy_id ' . $taxonomy_id . ' is already used at organism_id ' . $organism_id . '.');
                }

                if ($organism_id > 0) {
                    $organism = Organisms::findFirst("id = $organism_id");
                    if (!$organism) {
                        return $this->flashSession->error('ERROR: Could not get $organisms data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $organism->delete(); //Should be soft-delete (active=N);
                    } else {
                        $organism->name = $name;
                        $organism->taxonomy_id = $taxonomy_id;
                        $organism->taxonomy = $taxonomy;
                        $organism->sort_order = $sort_order;
                        $organism->active = $active;
                    }
                } else {
                    $organism = new Organisms();
                    $organism->name = $name;
                    $organism->taxonomy_id = $taxonomy_id;
                    $organism->taxonomy = $taxonomy;
                    $organism->sort_order = $sort_order;
                    $organism->active = $active;
                }

                /*
                 * Save user data values.
                 */
                if ($organism->save() == false) {
                    foreach ($organism->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($organism_id == -1) {
                        $this->flashSession->success('Organism: ' . $organism->name . ' is created.');
                    } elseif ($organism->active == 'N') {
                        $this->flashSession->success('Organism: ' . $organism->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('Organism: ' . $organism->name . ' record is changed.');
                    }

                }

            }
        } else {
            Tag::appendTitle(' | Organisms');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $organisms = Organisms::find(array(
                "order" => "sort_order IS NULL ASC, sort_order ASC"
            ));

            $this->view->setVar('organisms', $organisms);

        }
    }

    public function instrumentTypesAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $instrument_type_id = $request->getPost('instrument_type_id', 'int');
                $name = $request->getPost('name', array('striptags', 'name_filter'));
                $platform_code = $request->getPost('platform_code', array('striptags', 'trim'));
                $sort_order = $request->getPost('sort_order', 'int');
                $slots_per_run = $request->getPost('slots_per_run', 'int');
                $slots_array_json = $request->getPost('slots_array_json', array('striptags', 'trim'));
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($instrument_type_id)) {
                    return $this->flashSession->error('ERROR: Undefined $instrument_type_id value ' . $instrument_type_id . '.');
                }

                $slots_array_json_decode = (array)json_decode($slots_array_json);
                if (!$slots_array_json_decode and !empty($name)) {
                    return $this->flashSession->error('ERROR: $slots_array_json' . $slots_array_json . ' has problem.' . json_last_error_msg());
                }

                if (count($slots_array_json_decode) != $slots_per_run and !empty($name)) {
                    return $this->flashSession->error('ERROR: $slots_array_json' . $slots_array_json . ' have ' . count($slots_array_json_decode) . ' of slot(s). however slots_per_run is ' . $slots_per_run . '. These should be equal.');
                }

                if ($instrument_type_id > 0) {
                    $instrument_type = InstrumentTypes::findFirst("id = $instrument_type_id");
                    if (!$instrument_type) {
                        return $this->flashSession->error('ERROR: Could not get $instrument_types data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $instrument_type->delete(); //Should be soft-delete (active=N);
                    } else {
                        $instrument_type->name = $name;
                        $instrument_type->platform_code = $platform_code;
                        $instrument_type->sort_order = $sort_order;
                        $instrument_type->slots_per_run = $slots_per_run;
                        $instrument_type->slots_array_json = $slots_array_json;
                        $instrument_type->active = $active;
                    }
                } else {
                    $instrument_type = new InstrumentTypes();
                    $instrument_type->name = $name;
                    $instrument_type->platform_code = $platform_code;
                    $instrument_type->sort_order = $sort_order;
                    $instrument_type->slots_per_run = $slots_per_run;
                    $instrument_type->slots_array_json = $slots_array_json;
                    $instrument_type->active = $active;
                }

                /*
                 * Save user data values.
                 */
                if ($instrument_type->save() == false) {
                    foreach ($instrument_type->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($instrument_type_id == -1) {
                        $this->flashSession->success('Instrument Type: ' . $instrument_type->name . ' is created.');
                    } elseif ($instrument_type->active == 'N') {
                        $this->flashSession->success('Instrument Type: ' . $instrument_type->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('Instrument Type: ' . $instrument_type->name . ' record is changed.');
                    }

                }

            }
        } else {
            Tag::appendTitle(' | Instrument Types');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $instrument_types = InstrumentTypes::find(array(
                "order" => "sort_order ASC"
            ));

            $platforms = $this->modelsManager->createBuilder()
                ->addFrom('Platforms', 'p')
                ->join('Steps', 's.platform_code = p.platform_code', 's')
                ->where('s.step_phase_code = "FLOWCELL"')
                ->groupBy('p.platform_code')
                ->getQuery()
                ->execute();

            $this->view->setVar('instrument_types', $instrument_types);
            $this->view->setVar('platforms', $platforms);

        }
    }

    public function stepInstrumentTypeSchemesAction($instrument_type_id)
    {
        $request = $this->request;
        $instrument_type = InstrumentTypes::findFirst($instrument_type_id);
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $new_step_id_array = $request->getPost('new_step_id_array', array('striptags'));
                $del_step_id_array = $request->getPost('del_step_id_array', array('striptags'));

                $stepInstrumentTypeSchemes = array();
                $i = 0;
                $new_step_instrument_type_scheme_step_name = array();
                $del_step_instrument_type_scheme_step_name = array();
                if (count($new_step_id_array)) {
                    foreach ($new_step_id_array as $step_id) {
                        $stepInstrumentTypeSchemes[$i] = new StepInstrumentTypeSchemes();
                        $stepInstrumentTypeSchemes[$i]->step_id = $step_id;
                        $stepInstrumentTypeSchemes[$i]->instrument_type_id = $instrument_type_id;
                        $new_step_instrument_type_scheme_step_name[] = Steps::findFirst($step_id);
                        $i++;
                    }
                }
                if (count($del_step_id_array)) {
                    foreach ($del_step_id_array as $step_id) {
                        $stepInstrumentTypeSchemes[$i] = StepInstrumentTypeSchemes::find("instrument_type_id = $instrument_type_id AND step_id = $step_id");
                        $stepInstrumentTypeSchemes[$i]->delete();
                        $del_step_instrument_type_scheme_name[] = Steps::findFirst($step_id);
                        $i++;
                    }
                }

                if ($i > 0) {
                    /*
                     * Save $oligobarcodeSchemeAllows data values.
                     */
                    $instrument_type->StepInstrumentTypeSchemes = $stepInstrumentTypeSchemes;
                    if ($instrument_type->save() == false) {
                        foreach ($instrument_type->getMessages() as $message) {
                            $this->flashSession->error((string)$message);
                        }
                        return false;
                    } else {
                        if (count($new_step_instrument_type_scheme_step_name)) {
                            $new_step_instrument_type_scheme_step_name_str = implode(",", $new_step_instrument_type_scheme_step_name);
                            $this->flashSession->success('Step: ' . $new_step_instrument_type_scheme_step_name_str . ' is added.');
                        }
                        if (count($del_step_instrument_type_scheme_step_name)) {
                            $del_step_instrument_type_scheme_step_name_str = implode(",", $del_step_instrument_type_scheme_step_name);
                            $this->flashSession->success('Step: ' . $del_step_instrument_type_scheme_step_name_str . ' is removeed.');
                        }

                    }
                }
            }
        } else {
            Tag::appendTitle(' | ' . $instrument_type->name . ' | Step - Instrument Type Schemes');
            $this->view->setVar('instrument_type', $instrument_type);

            $step_instrument_type_schemes = $instrument_type->StepInstrumentTypeSchemes;
            $this->view->setVar('step_instrument_type_schemes', $step_instrument_type_schemes);

            $step_instrument_type_scheme_step_id = array();
            foreach ($step_instrument_type_schemes as $step_instrument_type_scheme) {
                $step_instrument_type_scheme_step_id[] = $step_instrument_type_scheme->step_id;
            }
            /*
             * Create candidate step_id list whom not be joined step_instrument_type_schemes (!=$step_instrument_type_scheme_step_id[])
             */
            $step_instrument_type_scheme_candidate_tmp = $this->modelsManager->createBuilder()
                ->addFrom('Steps', 'st')
                ->where('st.step_phase_code = "FLOWCELL"');

            if (count($step_instrument_type_scheme_step_id)) {
                $step_instrument_type_scheme_candidate_tmp = $step_instrument_type_scheme_candidate_tmp
                    ->notInWhere('st.id', $step_instrument_type_scheme_step_id);
            }


            $step_instrument_type_scheme_candidate = $step_instrument_type_scheme_candidate_tmp
                ->andWhere('st.active = "Y"')
                ->getQuery()
                ->execute();
            $this->view->setVar('step_instrument_type_scheme_candidate', $step_instrument_type_scheme_candidate);

        }

    }

    public function instrumentsAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $instrument_id = $request->getPost('instrument_id', 'int');
                $name = $request->getPost('name', array('striptags', 'name_filter', 'upper'));
                $instrument_number = $request->getPost('instrument_number', array('striptags', 'trim'));
                $nickname = $request->getPost('nickname', array('striptags', 'trim'));
                $instrument_type_id = $request->getPost('instrument_type_id', 'int');
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($instrument_id)) {
                    return $this->flashSession->error('ERROR: Undefined $instrument_id value ' . $instrument_id . '.');
                }

                if (!empty($name) and count(Instruments::find("instrument_number = '$instrument_number' AND id != $instrument_id"))) {
                    return $this->flashSession->error('ERROR: instrument_number ' . $instrument_number . ' is already used by instrument_id ' . $instrument_id . '.');
                }

                if ($instrument_id > 0) {
                    $instrument = Instruments::findFirst("id = $instrument_id");
                    if (!$instrument) {
                        return $this->flashSession->error('ERROR: Could not get $instruments data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $instrument->delete(); //Should be soft-delete (active=N);
                    } else {
                        $instrument->name = $name;
                        $instrument->instrument_number = $instrument_number;
                        $instrument->nickname = $nickname;
                        $instrument->instrument_type_id = $instrument_type_id;
                        $instrument->active = $active;
                    }
                } else {
                    $instrument = new Instruments();
                    $instrument->name = $name;
                    $instrument->instrument_number = $instrument_number;
                    $instrument->nickname = $nickname;
                    $instrument->instrument_type_id = $instrument_type_id;
                    $instrument->active = $active;
                }

                /*
                 * Save Instrument data values.
                 */
                if ($instrument->save() == false) {
                    foreach ($instrument->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($instrument_id == -1) {
                        $this->flashSession->success('Instrument: ' . $instrument->name . ' is created.');
                    } elseif ($instrument->active == 'N') {
                        $this->flashSession->success('Instrument: ' . $instrument->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('Instrument: ' . $instrument->name . ' record is changed.');
                    }
                }

            }
        } else {
            Tag::appendTitle(' | Instruments');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $instruments = Instruments::find(array(
                "order" => "nickname ASC"
            ));
            $instrument_types = InstrumentTypes::find("active = 'Y'");

            $this->view->setVar('instruments', $instruments);
            $this->view->setVar('instrument_types', $instrument_types);

        }
    }

    public function seqRunTypeSchemesAction($instrument_type_id)
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();
                $seq_run_type_scheme_arrays = $request->getPost('seq_run_type_scheme_arrays');
                foreach ($seq_run_type_scheme_arrays as $seq_run_type_scheme_arr) {
                    $seq_runmode_type_id = $seq_run_type_scheme_arr[0];
                    $seq_runread_type_id = $seq_run_type_scheme_arr[1];
                    $seq_runcycle_type_id = $seq_run_type_scheme_arr[2];
                    $active = $seq_run_type_scheme_arr[3];
                    //echo "$seq_runmode_type_id $seq_runread_type_id $seq_runcycle_type_id $active\n";

                    $seq_run_type_scheme = SeqRunTypeSchemes::findFirst(
                        "instrument_type_id = $instrument_type_id
                          AND seq_runmode_type_id = $seq_runmode_type_id
                          AND seq_runread_type_id = $seq_runread_type_id
                          AND seq_runcycle_type_id = $seq_runcycle_type_id"
                    );

                    $count = 0;
                    if ($active == 'Y') {
                        if (!$seq_run_type_scheme) {
                            $seq_run_type_scheme = new SeqRunTypeSchemes();
                            $seq_run_type_scheme->instrument_type_id = $instrument_type_id;
                            $seq_run_type_scheme->seq_runmode_type_id = $seq_runmode_type_id;
                            $seq_run_type_scheme->seq_runread_type_id = $seq_runread_type_id;
                            $seq_run_type_scheme->seq_runcycle_type_id = $seq_runcycle_type_id;
                            $seq_run_type_scheme->active = 'Y';
                        } else {
                            $seq_run_type_scheme->active = 'Y';
                        }
                        $count++;
                    } elseif ($seq_run_type_scheme) {
                        $seq_run_type_scheme->delete(); //Should be soft deleted (active = 'N');
                        $count++;
                    }

                    /*
                     * Save SeqRunTypeScheme data values.
                     */
                    if ($count) {
                        if ($seq_run_type_scheme->save() == false) {
                            foreach ($seq_run_type_scheme->getMessages() as $message) {
                                $this->flashSession->error((string)$message);
                            }
                            return false;
                        }
                    }
                }

            }
        } else {
            Tag::appendTitle(' | Seq. Run Type Schemes');


            $instrument_type = InstrumentTypes::findFirst("id = $instrument_type_id");
            $this->view->setVar('instrument_type', $instrument_type);

            $seq_runmode_types = SeqRunmodeTypes::find(array(
                "order" => "sort_order ASC"
            ));
            $seq_runread_types = SeqRunreadTypes::find(array(
                "order" => "sort_order ASC"
            ));
            $seq_runcycle_types = SeqRuncycleTypes::find(array(
                "order" => "sort_order ASC"
            ));
            $this->view->setVars(array(
                'seq_runmode_types' => $seq_runmode_types,
                'seq_runread_types' => $seq_runread_types,
                'seq_runcycle_types' => $seq_runcycle_types
            ));

            /*
             * Set checkbox checked values
             */
            $checkbox_seq_runmode_type_id_checked = array();
            $checkbox_seq_runread_type_id_checked = array();
            $checkbox_seq_runcycle_type_id_checked = array();
            $seq_run_type_schemes = SeqRunTypeSchemes::find("instrument_type_id = $instrument_type_id");
            foreach ($seq_run_type_schemes as $seq_run_type_scheme) {
                $checkbox_seq_runmode_type_id = 'seq_runmode_type-' . $seq_run_type_scheme->seq_runmode_type_id;
                $checkbox_seq_runread_type_id = 'seq_runread_type-' . $seq_run_type_scheme->seq_runmode_type_id . '-' . $seq_run_type_scheme->seq_runread_type_id;
                $checkbox_seq_runcycle_type_id = 'seq_runcycle_type-' . $seq_run_type_scheme->seq_runmode_type_id . '-' . $seq_run_type_scheme->seq_runread_type_id . '-' . $seq_run_type_scheme->seq_runcycle_type_id;

                if ($seq_run_type_scheme->active == 'Y') {
                    if (empty($checkbox_seq_runmode_type_id_checked[$checkbox_seq_runmode_type_id])) { //Check for duplicates
                        $this->tag->setDefault($checkbox_seq_runmode_type_id, true);
                        $checkbox_seq_runmode_type_id_checked[$checkbox_seq_runmode_type_id] = 1;
                    }
                    if (empty($checkbox_seq_runread_type_id_checked[$checkbox_seq_runread_type_id])) { //Check for duplicates
                        $this->tag->setDefault($checkbox_seq_runread_type_id, true);
                        $checkbox_seq_runread_type_id_checked[$checkbox_seq_runread_type_id] = 1;
                    }
                    if (empty($checkbox_seq_runcycle_type_id_checked[$checkbox_seq_runcycle_type_id])) { //Check for duplicates
                        $this->tag->setDefault($checkbox_seq_runcycle_type_id, true);
                        $checkbox_seq_runcycle_type_id_checked[$checkbox_seq_runcycle_type_id] = 1;
                    }
                }
            }
            $this->view->setVars(array(
                'checkbox_seq_runmode_type_id_checked' => $checkbox_seq_runmode_type_id_checked,
                'checkbox_seq_runread_type_id_checked' => $checkbox_seq_runread_type_id_checked,
                'checkbox_seq_runcycle_type_id_checked' => $checkbox_seq_runcycle_type_id_checked
            ));
        }
    }

    public function seqRunmodeTypesAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $seq_runmode_type_id = $request->getPost('seq_runmode_type_id', 'int');
                $name = $request->getPost('name', array('striptags', 'trim'));
                $platform_code = $request->getPost('platform_code', array('striptags', 'trim'));
                $lane_per_flowcell = $request->getPost('lane_per_flowcell', 'int');
                $sort_order = $request->getPost('sort_order', 'int');
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($seq_runmode_type_id)) {
                    return $this->flashSession->error('ERROR: Undefined $seq_runmode_type_id value ' . $seq_runmode_type_id . '.');
                }

                if ($seq_runmode_type_id > 0) {
                    $seq_runmode_type = SeqRunmodeTypes::findFirst("id = $seq_runmode_type_id");
                    if (!$seq_runmode_type) {
                        return $this->flashSession->error('ERROR: Could not get $seq_runmode_types data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $seq_runmode_type->delete(); //Should be soft-delete (active=N);
                    } else {
                        $seq_runmode_type->name = $name;
                        $seq_runmode_type->platform_code = $platform_code;
                        $seq_runmode_type->lane_per_flowcell = $lane_per_flowcell;
                        $seq_runmode_type->sort_order = $sort_order;
                        $seq_runmode_type->active = $active;
                    }
                } else {
                    $seq_runmode_type = new SeqRunmodeTypes();
                    $seq_runmode_type->name = $name;
                    $seq_runmode_type->platform_code = $platform_code;
                    $seq_runmode_type->lane_per_flowcell = $lane_per_flowcell;
                    $seq_runmode_type->sort_order = $sort_order;
                    $seq_runmode_type->active = $active;
                }

                /*
                 * Save SeqRunmodeType data values.
                 */
                if ($seq_runmode_type->save() == false) {
                    foreach ($seq_runmode_type->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($seq_runmode_type_id == -1) {
                        $this->flashSession->success('SeqRunmodeType: ' . $seq_runmode_type->name . ' is created.');
                    } elseif ($seq_runmode_type->active == 'N') {
                        $this->flashSession->success('SeqRunmodeType: ' . $seq_runmode_type->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('SeqRunmodeType: ' . $seq_runmode_type->name . ' record is changed.');
                    }
                }

            }
        } else {
            Tag::appendTitle(' | Seq Run Mode Types');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $seq_runmode_types = SeqRunmodeTypes::find(array(
                "order" => "sort_order ASC"
            ));
            $this->view->setVar('seq_runmode_types', $seq_runmode_types);

            $platforms = Platforms::find(array(
                "active = 'Y'"
            ));
            $this->view->setVar('platforms', $platforms);

        }
    }

    public function seqRunreadTypesAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {

                $this->view->disable();
                $seq_runread_type_id = $request->getPost('seq_runread_type_id', 'int');
                $name = $request->getPost('name', array('striptags', 'trim', 'name_filter'));
                $sort_order = $request->getPost('sort_order', 'int');
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($seq_runread_type_id)) {
                    return $this->flashSession->error('ERROR: Undefined $seq_runread_type_id value ' . $seq_runread_type_id . '.');
                }

                if ($seq_runread_type_id > 0) {
                    $seq_runread_type = SeqRunreadTypes::findFirst("id = $seq_runread_type_id");
                    if (!$seq_runread_type) {
                        return $this->flashSession->error('ERROR: Could not get $seq_runread_types data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $seq_runread_type->delete(); //Should be soft-delete (active=N);
                    } else {
                        $seq_runread_type->name = $name;
                        $seq_runread_type->sort_order = $sort_order;
                        $seq_runread_type->active = $active;
                    }
                } else {
                    $seq_runread_type = new SeqRunreadTypes();
                    $seq_runread_type->name = $name;
                    $seq_runread_type->sort_order = $sort_order;
                    $seq_runread_type->active = $active;
                }

                /*
                 * Save SeqRunreadType data values.
                 */
                if ($seq_runread_type->save() == false) {
                    foreach ($seq_runread_type->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($seq_runread_type_id == -1) {
                        $this->flashSession->success('SeqRunreadType: ' . $seq_runread_type->name . ' is created.');
                    } elseif ($seq_runread_type->active == 'N') {
                        $this->flashSession->success('SeqRunreadType: ' . $seq_runread_type->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('SeqRunreadType: ' . $seq_runread_type->name . ' record is changed.');
                    }
                }

            }
        } else {
            Tag::appendTitle(' | Seq Run Mode Types');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $seq_runread_types = SeqRunreadTypes::find(array(
                "order" => "sort_order ASC"
            ));

            $this->view->setVar('seq_runread_types', $seq_runread_types);

        }
    }

    public function seqRuncycleTypesAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $seq_runcycle_type_id = $request->getPost('seq_runcycle_type_id', 'int');
                $name = $request->getPost('name', array('striptags', 'trim'));
                $lane_per_flowcell = $request->getPost('lane_per_flowcell', 'int');
                $sort_order = $request->getPost('sort_order', 'int');
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($seq_runcycle_type_id)) {
                    return $this->flashSession->error('ERROR: Undefined $seq_runcycle_type_id value ' . $seq_runcycle_type_id . '.');
                }

                if ($seq_runcycle_type_id > 0) {
                    $seq_runcycle_type = SeqRuncycleTypes::findFirst("id = $seq_runcycle_type_id");
                    if (!$seq_runcycle_type) {
                        return $this->flashSession->error('ERROR: Could not get $seq_runcycle_types data values.');
                    }
                    if (empty($name) and $active == 'N') {
                        $seq_runcycle_type->delete(); //Should be soft-delete (active=N);
                    } else {
                        $seq_runcycle_type->name = $name;
                        $seq_runcycle_type->lane_per_flowcell = $lane_per_flowcell;
                        $seq_runcycle_type->sort_order = $sort_order;
                        $seq_runcycle_type->active = $active;
                    }
                } else {
                    $seq_runcycle_type = new SeqRuncycleTypes();
                    $seq_runcycle_type->name = $name;
                    $seq_runcycle_type->lane_per_flowcell = $lane_per_flowcell;
                    $seq_runcycle_type->sort_order = $sort_order;
                    $seq_runcycle_type->active = $active;
                }

                /*
                 * Save SeqRuncycleType data values.
                 */
                if ($seq_runcycle_type->save() == false) {
                    foreach ($seq_runcycle_type->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($seq_runcycle_type_id == -1) {
                        $this->flashSession->success('SeqRuncycleType: ' . $seq_runcycle_type->name . ' is created.');
                    } elseif ($seq_runcycle_type->active == 'N') {
                        $this->flashSession->success('SeqRuncycleType: ' . $seq_runcycle_type->name . ' is change to in-active.');
                    } else {
                        $this->flashSession->success('SeqRuncycleType: ' . $seq_runcycle_type->name . ' record is changed.');
                    }
                }

            }
        } else {
            Tag::appendTitle(' | Seq Run Mode Types');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $seq_runcycle_types = SeqRuncycleTypes::find(array(
                "order" => "sort_order ASC"
            ));

            $this->view->setVar('seq_runcycle_types', $seq_runcycle_types);

        }
    }

    public function seqtemplatesAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $seqtemplate_id = $request->getPost('seqtemplate_id', 'int');

                $name = $request->getPost('name', array('striptags', 'name_filter'));
                $target_conc = $request->getPost('target_conc', 'float');
                $target_vol = $request->getPost('target_vol', 'float');
                $target_dw_vol = $request->getPost('target_dw_vol', 'float');
                $initial_conc = $request->getPost('initial_conc', 'float');
                $initial_vol = $request->getPost('initial_vol', 'float');
                $final_conc = $request->getPost('final_conc', 'float');
                $final_vol = $request->getPost('final_vol', 'float');
                $final_dw_vol = $request->getPost('final_dw_vol', 'float');
                $started_at = ($request->getPost('started_at', 'striptags')) ? $request->getPost('started_at', 'striptags') : null;
                $finished_at = ($request->getPost('finished_at', 'striptags')) ? $request->getPost('finished_at', 'striptags') : null;
                $active = ($request->getPost('active', array('striptags'))) ? $request->getPost('active', array('striptags')) : null;

                if (empty($seqtemplate_id)) {
                    return $this->flashSession->error('ERROR: Undefined $seqtemplate_id value ' . $seqtemplate_id . '.');
                }

                if ($seqtemplate_id > 0) {
                    $seqtemplate = Seqtemplates::findFirst("id = $seqtemplate_id");
                    $step_entries = StepEntries::findFirst("seqtemplate_id = $seqtemplate_id");
                    if (!$seqtemplate) {
                        return $this->flashSession->error('ERROR: Could not get $seqtemplates data values.');
                    }
                    if (empty($name) and $active == 'N') { //In the case of delete
                        if ($step_entries) {
                            if ($step_entries->delete()) {
                                foreach ($step_entries->getMessages() as $message) {
                                    $this->flashSession->error((string)$message);
                                }
                            }
                        }
                        $seqtemplate_assocs = SeqtemplateAssocs::find(array(
                                "seqtemplate_id = :seqtemplate_id:",
                                "bind" => array(
                                    "seqtemplate_id" => $seqtemplate_id
                                )
                            )
                        );
                        foreach ($seqtemplate_assocs as $seqtemplate_assoc) {
                            if ($seqtemplate_assoc->delete() == false) {
                                foreach ($seqtemplate_assoc->getMessages() as $message) {
                                    $this->flashSession->error((string)$message);
                                }
                                return false;
                            }
                        }
                        if ($seqtemplate->delete() == false) { //Not soft-delete.
                            foreach ($seqtemplate->getMessages() as $message) {
                                $this->flashSession->error((string)$message);
                            }
                            return false;
                        }
                        $this->flashSession->success('Seqtemplate: ' . $seqtemplate->name . ' is deleted.');

                    } else { //In the case of edit.
                        $seqtemplate->name = $name;
                        $seqtemplate->target_conc = ( $target_conc ) ? $target_conc : null;
                        $seqtemplate->target_vol = ( $target_vol ) ? $target_vol : null;
                        $seqtemplate->target_dw_vol = ( $target_dw_vol ) ? $target_dw_vol : null;
                        $seqtemplate->initial_conc = ( $initial_conc ) ? $initial_conc : null;
                        $seqtemplate->initial_vol = ( $initial_vol ) ? $initial_vol : null;
                        $seqtemplate->final_conc = ( $final_conc ) ? $final_conc : null;
                        $seqtemplate->final_vol = ( $final_vol ) ? $final_vol : null;
                        $seqtemplate->final_dw_vol = ( $final_dw_vol ) ? $final_dw_vol : null;
                        $seqtemplate->started_at = ( $started_at ) ? $started_at : null;
                        $seqtemplate->finished_at = ( $finished_at ) ? $finished_at : null;
                        /*
                         * Save Seqtemplate data values.
                         */
                        if ($seqtemplate->save() == false) {
                            foreach ($seqtemplate->getMessages() as $message) {
                                $this->flashSession->error((string)$message);
                            }
                            return false;
                        } else {
                            $this->flashSession->success('Seqtemplate: ' . $seqtemplate->name . ' record is changed.');
                        }
                    }
                } else { //In the case of create.
                    $seqtemplate = new Seqtemplates();
                    $seqtemplate->name = $name;
                    $seqtemplate->target_conc = ( $target_conc ) ? $target_conc : null;
                    $seqtemplate->target_vol = ( $target_vol ) ? $target_vol : null;
                    $seqtemplate->target_dw_vol = ( $target_dw_vol ) ? $target_dw_vol : null;
                    $seqtemplate->initial_conc = ( $initial_conc ) ? $initial_conc : null;
                    $seqtemplate->initial_vol = ( $initial_vol ) ? $initial_vol : null;
                    $seqtemplate->final_conc = ( $final_conc ) ? $final_conc : null;
                    $seqtemplate->final_vol = ( $final_vol ) ? $final_vol : null;
                    $seqtemplate->final_dw_vol = ( $final_dw_vol ) ? $final_dw_vol : null;
                    $seqtemplate->started_at = ( $started_at ) ? $started_at : null;
                    $seqtemplate->finished_at = ( $finished_at ) ? $finished_at : null;
                    /*
                     * Save Seqtemplate data values.
                     */
                    if ($seqtemplate->save() == false) {
                        foreach ($seqtemplate->getMessages() as $message) {
                            $this->flashSession->error((string)$message);
                        }
                        return false;
                    } else {
                        $this->flashSession->success('Seqtemplate: ' . $seqtemplate->name . ' is created.');
                    }
                }


            }
        } else {
            Tag::appendTitle(' | Seqtemplates');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $query = $this->request->get('q', 'striptags');
            $this->view->setVar('query', $query);

            if ($query) {
                $seqtemplates = Seqtemplates::find(array(
                    "name LIKE '%" . $query . "%'",
                    "order" => "created_at DESC"
                ));
            } else {
                $seqtemplates = Seqtemplates::find(array(
                    "order" => "created_at DESC"
                ));
            }

            $this->view->setVar('seqtemplates', $seqtemplates);

        }
    }

    public function seqtemplateCopyAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $seqtemplate_id = $request->getPost('seqtemplate_id', 'int');
                if (empty($seqtemplate_id)) {
                    return $this->flashSession->error('ERROR: Undefined $seqtemplate_id value ' . $seqtemplate_id . '.');
                }

                if ($seqtemplate_id > 0) {
                    $seqtemplate = Seqtemplates::findFirst("id = $seqtemplate_id");
                    if (!$seqtemplate) {
                        return $this->flashSession->error('ERROR: Could not get $seqtemplates data values.');
                    }

                    $seqtemplate_new = new Seqtemplates();
                    $seqtemplate_new->name = $seqtemplate->name . '_Copy';
                    $seqtemplate_new->target_conc = $seqtemplate->target_conc;
                    $seqtemplate_new->target_vol = $seqtemplate->target_vol;
                    $seqtemplate_new->target_dw_vol = $seqtemplate->target_dw_vol;
                    $seqtemplate_new->initial_conc = $seqtemplate->initial_conc;
                    $seqtemplate_new->initial_vol = $seqtemplate->initial_vol;
                    $seqtemplate_new->final_conc = $seqtemplate->final_conc;
                    $seqtemplate_new->final_vol = $seqtemplate->final_vol;
                    $seqtemplate_new->final_dw_vol = $seqtemplate->final_dw_vol;



                    $seqtemplate_assocs = SeqtemplateAssocs::find(array(
                            "seqtemplate_id = :seqtemplate_id:",
                            "bind" => array(
                                "seqtemplate_id" => $seqtemplate_id
                            )
                        )
                    );

                    $seqtemplate_assocs_new = [];
                    $i = 0;
                    foreach ($seqtemplate_assocs as $seqtemplate_assoc) {
                        $seqtemplate_assocs_new[$i] = new SeqtemplateAssocs();
                        $seqtemplate_assocs_new[$i]->seqtemplate_id = $seqtemplate_new->id;
                        $seqtemplate_assocs_new[$i]->seqlib_id = $seqtemplate_assoc->seqlib_id;
                        $seqtemplate_assocs_new[$i]->conc_factor = $seqtemplate_assoc->conc_factor;
                        $seqtemplate_assocs_new[$i]->input_vol = $seqtemplate_assoc->input_vol;
                        $i++;
                    }

                    $seqtemplate_new->SeqtemplateAssocs = $seqtemplate_assocs_new;

                    $step_entry = StepEntries::findFirst("seqtemplate_id = $seqtemplate_id");
                    $step_entries_new = array();
                    $step_entries_new[0] = new StepEntries;
                    $step_entries_new[0]->step_phase_code = $step_entry->step_phase_code;
                    $step_entries_new[0]->step_id = $step_entry->step_id;
                    $step_entries_new[0]->user_id = $this->session->get('auth')['id'];

                    $seqtemplate_new->StepEntries = $step_entries_new;

                    /*
                     * Save Seqtemplate data values.
                     */
                    if ($seqtemplate_new->save() == false) {
                        foreach ($seqtemplate_new->getMessages() as $message) {
                            $this->flashSession->error((string)$message);
                        }
                        return false;
                    } else {
                        $this->flashSession->success('Seqtemplate: ' . $seqtemplate->name . ' is copied to .' . $seqtemplate->name . '_Copy');
                    }

                }
            }
        }
    }

    public
    function seqtemplateAssocsAction($seqtemplate_id)
    {
        $request = $this->request;
        $seqtemplate_assocs = SeqtemplateAssocs::find(array(
            "seqtemplate_id = :seqtemplate_id:",
            "bind" => array(
                "seqtemplate_id" => $seqtemplate_id
            )
        ));
        $seqtemplate = Seqtemplates::findFirst($seqtemplate_id);
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $new_seqlib_id_array = $request->getPost('new_seqlib_id_array', array('striptags'));
                $new_seqlib_id_array = array_unique($new_seqlib_id_array); //to unique seqlib_id on array
                $new_seqlib_id_array = array_values($new_seqlib_id_array); //re-indexed array

                $del_seqlib_id_array = $request->getPost('del_seqlib_id_array', array('striptags'));
                $del_seqlib_id_array = array_unique($del_seqlib_id_array); //to unique seqlib_id on array
                $del_seqlib_id_array = array_values($del_seqlib_id_array); //re-indexed array

                $seqtemplateAssocSeqlibs = array();
                $i = 0;
                $new_seqlib_name = array();
                $del_seqlib_name = array();
                if (count($new_seqlib_id_array)) {
                    foreach ($new_seqlib_id_array as $seqlib_id) {
                        $seqtemplateAssocSeqlibs[$i] = new SeqtemplateAssocs();
                        $seqtemplateAssocSeqlibs[$i]->seqtemplate_id = $seqtemplate_id;
                        $seqtemplateAssocSeqlibs[$i]->seqlib_id = $seqlib_id;
                        $new_seqlib_name[] = Seqlibs::findFirst($seqlib_id)->name;
                        $i++;
                    }
                }
                if (count($del_seqlib_id_array)) {
                    foreach ($del_seqlib_id_array as $seqlib_id) {
                        $seqtemplateAssocSeqlib = SeqtemplateAssocs::findFirst(array(
                            "seqtemplate_id = :seqtemplate_id: AND seqlib_id = :seqlib_id:",
                            "bind" => array(
                                "seqtemplate_id" => $seqtemplate_id,
                                "seqlib_id" => $seqlib_id
                            )
                        ));
                        if (count($seqtemplateAssocSeqlib)) {
                            if ($seqtemplateAssocSeqlib->delete() == false) {
                                foreach ($seqtemplateAssocSeqlib->getMessages() as $message) {
                                    $this->flashSession->error((string)$message);
                                }
                                return false;
                            }
                            $del_seqlib_name[] = Seqlibs::findFirst($seqlib_id)->name;
                            $i++;
                        }
                    }
                }

                if ($i > 0) {
                    /*
                     * Save $oligobarcodeSchemeOligobarcodes data values.
                     */
                    $seqtemplate->SeqtemplateAssocs = $seqtemplateAssocSeqlibs;
                    if ($seqtemplate->save() == false) {
                        foreach ($seqtemplate->getMessages() as $message) {
                            $this->flashSession->error((string)$message);
                        }
                        return false;
                    } else {
                        if (count($new_seqlib_name)) {
                            $new_seqlib_name_str = implode(",", $new_seqlib_name);
                            $this->flashSession->success('Seqtemplate Assoc.: ' . $new_seqlib_name_str . ' is added.');
                        }
                        if (count($del_seqlib_name)) {
                            $del_seqlib_name_str = implode(",", $del_seqlib_name);
                            $this->flashSession->success('Seqtemplate Assoc.: ' . $del_seqlib_name_str . ' is deleted.');
                        }

                    }
                }
            }
        } else {
            Tag::appendTitle(' | ' . $seqtemplate->name . ' | Seqtemplate Seqlibs.');
            $this->view->setVar('seqtemplate', $seqtemplate);
            $this->view->setVar('seqtemplate_assocs', $seqtemplate_assocs);
        }

    }


    public
    function showTubeSeqlibsAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_MAIN_LAYOUT);
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_AFTER_TEMPLATE);
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                $query = $this->request->getPost("pick_query", "striptags");
                $cherry_picking_id = $this->request->getPost("cherry_picking_id", "int");

                $seqlibs_tmp = $this->modelsManager->createBuilder()
                    ->columns(array('sl.*', 'se.*', 'pt.*', 'COUNT(sta.id) AS sta_count'))
                    ->addFrom('Seqlibs', 'sl')
                    ->join('Samples', 's.id = sl.sample_id', 's')
                    ->leftJoin('StepEntries', 'se.seqlib_id = sl.id', 'se')
                    ->leftJoin('Protocols', 'pt.id = sl.protocol_id', 'pt')
                    ->leftJoin('Steps', 'st.step_phase_code = pt.next_step_phase_code', 'st')
                    ->leftJoin('SeqtemplateAssocs', 'sta.seqlib_id = sl.id', 'sta');

                if ($query) {
                    $seqlibs_tmp = $seqlibs_tmp
                        ->where('s.name LIKE :query:', array("query" => '%' . $query . '%'))
                        ->orWhere('sl.name LIKE :query:', array("query" => '%' . $query . '%'));
                } elseif ($cherry_picking_id) {
                    $seqlibs_tmp = $seqlibs_tmp
                        ->leftJoin('CherryPickingSchemes', 'cps.seqlib_id = sl.id', 'cps')
                        ->where('cps.cherry_picking_id = :cherry_picking_id:', array("cherry_picking_id" => $cherry_picking_id));
                } else {
                    return false;
                }
                $seqlibs = $seqlibs_tmp
                    ->groupBy('sl.id, se.id, pt.id, sta.id')
                    ->orderBy('sl.name ASC')
                    ->getQuery()
                    ->execute();

                $this->view->setVar('seqlibs', $seqlibs);
            }
        }
    }

    public
    function flowcellsAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $flowcell_id = $request->getPost('flowcell_id', 'int');
                $name = $request->getPost('name', array('striptags', 'name_filter'));
                $seq_run_type_scheme_id = ($request->getPost('seq_run_type_scheme_id', 'int')) ? $request->getPost('seq_run_type_scheme_id', 'int') : null;
                $seq_run_type_scheme = SeqRunTypeSchemes::findFirst($seq_run_type_scheme_id);
                $seq_runmode_type_id = ($seq_run_type_scheme) ? $seq_run_type_scheme->seq_runmode_type_id : null;
                $run_number = ($request->getPost('run_number', 'int')) ? $request->getPost('run_number', 'int') : null;
                $instrument_id = ($request->getPost('instrument_id', 'int')) ? $request->getPost('instrument_id', 'int') : null;
                $side = ($request->getPost('side', 'striptags')) ? $request->getPost('side', 'striptags') : null;
                $dirname = ($request->getPost('dirname', 'striptags')) ? $request->getPost('dirname', 'striptags') : null;
                $run_started_date = ($request->getPost('run_started_date', 'striptags')) ? $request->getPost('run_started_date', 'striptags') : null;
                $run_finished_date = ($request->getPost('run_finished_date', 'striptags')) ? $request->getPost('run_finished_date', 'striptags') : null;
                $notes = ($request->getPost('notes', 'striptags')) ? $request->getPost('notes', 'striptags') : null;
                $active = ($request->getPost('active', 'striptags')) ? $request->getPost('active', 'striptags') : null;

                if (empty($flowcell_id)) {
                    return $this->flashSession->error('ERROR: Undefined $flowcell_id value ' . $flowcell_id . '.');
                } else {
                    $flowcell = Flowcells::findFirst($flowcell_id);
                    if (!$flowcell) {
                        return $this->flashSession->error('ERROR: Could not get $flowcells data values.');
                    } else if (empty($name) and $active == 'N') { //Case Delete
                        $step_entries = StepEntries::findFirst("flowcell_id = $flowcell_id");
                        if ($step_entries->delete()) {
                            foreach ($step_entries->getMessages() as $message) {
                                $this->flashSession->error((string)$message);
                            }
                        }
                        if ($flowcell->delete()) { //Not soft delete
                            foreach ($flowcell->getMessages() as $message) {
                                $this->flashSession->error((string)$message);
                            }
                            return false;
                        } else {
                            return $this->flashSession->error('flowcell ' . $flowcell->name . 'is removed.');
                        }
                    } else { //Case Edit
                        $flowcell->name = $name;
                        $flowcell->seq_run_type_scheme_id = $seq_run_type_scheme_id;
                        $flowcell->seq_runmode_type_id = $seq_runmode_type_id;
                        $flowcell->run_number = $run_number;
                        $flowcell->instrument_id = $instrument_id;
                        $flowcell->side = $side;
                        $flowcell->dirname = $dirname;
                        $flowcell->run_started_date = $run_started_date;
                        $flowcell->run_finished_date = $run_finished_date;
                        $flowcell->notes = $notes;
                    }
                }

                /*
                 * Save Flowcell data values.
                 */
                if ($flowcell->save() == false) {
                    foreach ($flowcell->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($flowcell_id == -1) {
                        $this->flashSession->success('Flowcell: ' . $flowcell->name . ' is created.');
                    } elseif ($active == 'N') {
                        $this->flashSession->success('Flowcell: ' . $flowcell->name . ' is deleted.');
                    } else {
                        $this->flashSession->success('Flowcell: ' . $flowcell->name . ' record is changed.');
                    }
                }

            }
        } else {
            Tag::appendTitle(' | Flowcells');
            $this->assets
                ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
                ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
                ->addCss('js/DataTables/media/css/dataTables.bootstrap.css');

            $flowcells = Flowcells::find(array(
                "order" => "created_at DESC"
            ));
            $this->view->setVar('flowcells', $flowcells);

            $instruments = $this->modelsManager->createBuilder()
                ->columns(array(
                    'i.id AS id',
                    'CONCAT(i.name, " (", it.name, ")") AS instrument_name'
                ))
                ->addFrom('Instruments', 'i')
                ->join('InstrumentTypes', 'it.id = i.instrument_type_id', 'it')
                ->where('i.active = "Y"')
                ->andWhere('it.active = "Y"')
                ->orderBy('it.sort_order ASC, i.instrument_number ASC')
                ->getQuery()
                ->execute();
            $this->view->setVar('instruments', $instruments);


        }
    }

    public
    function createSeqRunTypeSchemesSelectAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();
                $seq_run_type_scheme_id = $request->getPost('seq_run_type_scheme_id', 'int');
                $instrument_id = $request->getPost('instrument_id', 'int');
                if (empty($instrument_id)) {
                    $this->flashSession->error('ERROR: Undefined instrument_id value ' . $instrument_id . '.');
                }

                $instrument_type_id = Instruments::findFirst($instrument_id)->instrument_type_id;
                $seq_run_type_schemes = $this->modelsManager->createBuilder()
                    ->columns(array(
                        'srts.id AS id',
                        'CONCAT(srmt.name, " ", srrt.name, " ", srct.name) AS name'
                    ))
                    ->addFrom('SeqRunTypeSchemes', 'srts')
                    ->join('SeqRunmodeTypes', 'srmt.id = srts.seq_runmode_type_id', 'srmt')
                    ->join('SeqRunreadTypes', 'srrt.id = srts.seq_runread_type_id', 'srrt')
                    ->join('SeqRuncycleTypes', 'srct.id = srts.seq_runcycle_type_id', 'srct')
                    ->where('srts.active = "Y"')
                    ->andWhere('instrument_type_id = :instrument_type_id:', array(
                        'instrument_type_id' => $instrument_type_id
                    ))
                    ->orderBy('srmt.sort_order ASC, srrt.sort_order ASC, srct.sort_order ASC')
                    ->getQuery()
                    ->execute();

                echo '<select id="modal-seq_run_type_scheme_id" class="form-control">';
                if ($instrument_id == 0 or $seq_run_type_scheme_id == 0) {
                    echo '<option value="0">Please select Seq. Run Type Scheme...</option>';
                }
                foreach ($seq_run_type_schemes as $seq_run_type_scheme) {
                    if ($seq_run_type_scheme->id == $seq_run_type_scheme_id) {
                        echo '<option value="' . $seq_run_type_scheme->id . '" selected>' . $seq_run_type_scheme->name . '</option>';
                    } else {
                        echo '<option value="' . $seq_run_type_scheme->id . '">' . $seq_run_type_scheme->name . '</option>';
                    }
                }
                echo '</select>';
            }
        }
    }

    public
    function createFlowcellSideSelectAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();
                $side = $request->getPost('side', 'striptags');
                $instrument_id = $request->getPost('instrument_id', 'int');
                if (empty($instrument_id)) {
                    $this->flashSession->error('ERROR: Undefined instrument_id value ' . $instrument_id . '.');
                }

                $instrument_type_id = Instruments::findFirst($instrument_id)->instrument_type_id;
                $instrument_type = InstrumentTypes::findFirst($instrument_type_id);
                $slots_array = json_decode($instrument_type->slots_array_json);

                echo '<select id="modal-side" class="form-control">';
                if ($instrument_id == 0 or $side == 0) {
                    echo '<option value="0">Please select Flowcell Side...</option>';
                }
                foreach ($slots_array as $key => $slot) {
                    if ($slot == $side) {
                        echo '<option value="' . $slot . '" selected>' . $slot . '</option>';
                    } else {
                        echo '<option value="' . $slot . '">' . $slot . '</option>';
                    }
                }
                echo '</select>';
            }
        }
    }

    public
    function flowcellSeqlanesAction($flowcell_id)
    {
        $request = $this->request;

        $flowcell = Flowcells::findFirst($flowcell_id);
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();

                $seqlane_array_json = $request->getPost('seqlane_array_json', array('striptags'));
                $seqlane_array = json_decode($seqlane_array_json);

                $flowcellSeqlanes = array();
                $i = 0;
                $new_seqtemplate_name = array();
                $del_seqlane_name = array();
                if (count($seqlane_array)) {
                    foreach ($seqlane_array as $seqlane_index => $seqlane_obj) {
                        $id_str = $this->filter->sanitize($seqlane_obj->id_str, 'striptags');
                        $seqlane_id = $this->filter->sanitize($seqlane_obj->seqlane_id, 'int');
                        $apply_conc = ($this->filter->sanitize($seqlane_obj->apply_conc, 'float')) ? $this->filter->sanitize($seqlane_obj->apply_conc, 'float') : null;
                        $is_active = $this->filter->sanitize($seqlane_obj->is_active, 'striptags');
                        if ($is_active == 'Y') {
                            if (preg_match("/seqtemplate_id-/", $id_str)) {
                                $seqtemplate_id = str_replace("seqtemplate_id-", "", $id_str);
                                $number = $seqlane_index + 1;
                                $seqlane = Seqlanes::findFirst(array(
                                    "number = :number: AND flowcell_id = :flowcell_id:",
                                    "bind" => array(
                                        "number" => $number,
                                        "flowcell_id" => $flowcell_id
                                    )
                                ));
                                $seq_demultiplex_results = SeqDemultiplexResults::findBySeqlaneId($seqlane_id);
                                if ($seqlane) {
                                    /*
                                    if ($seqlane->seqtemplate_id == $seqtemplate_id) {
                                        continue;
                                    }
                                    */
                                    $flowcellSeqlanes[$i] = $seqlane;
                                    $flowcellSeqlanes[$i]->seqtemplate_id = $seqtemplate_id;
                                    $flowcellSeqlanes[$i]->apply_conc = $apply_conc;
                                    $flowcellSeqlanes[$i]->is_control = 'N';
                                    $flowcellSeqlanes[$i]->control_id = null;
                                    if (count($seq_demultiplex_results)) {
                                        if ($seq_demultiplex_results->delete() == false) {
                                            foreach ($seq_demultiplex_results->getMessages() as $message) {
                                                $this->flashSession->error((string)$message);
                                            }
                                            return false;
                                        } else {
                                            $this->flashSession->error('Demultiplex Results has been deleted on Lane #' . $number . '.');
                                        }
                                    }
                                } else {
                                    $flowcellSeqlanes[$i] = new Seqlanes();
                                    $flowcellSeqlanes[$i]->number = $number;
                                    $flowcellSeqlanes[$i]->flowcell_id = $flowcell_id;
                                    $flowcellSeqlanes[$i]->seqtemplate_id = $seqtemplate_id;
                                    $flowcellSeqlanes[$i]->apply_conc = $apply_conc;
                                    $flowcellSeqlanes[$i]->is_control = 'N';
                                }
                                $new_seqtemplate_name[] = Seqtemplates::findFirst($seqtemplate_id)->name;
                                $i++;
                            } else if (preg_match("/control_id-/", $id_str)) {
                                $control_id = str_replace("control_id-", "", $id_str);
                                $number = $seqlane_index + 1;
                                $seqlane = Seqlanes::findFirst(array(
                                    "number = :number: AND flowcell_id = :flowcell_id:",
                                    "bind" => array(
                                        "number" => $number,
                                        "flowcell_id" => $flowcell_id
                                    )
                                ));
                                if ($seqlane) {
                                    if ($seqlane->control_id == $control_id) {
                                        continue;
                                    }
                                    $flowcellSeqlanes[$i] = $seqlane;
                                    $flowcellSeqlanes[$i]->seqtemplate_id = null;
                                    $flowcellSeqlanes[$i]->apply_conc = $apply_conc;
                                    $flowcellSeqlanes[$i]->is_control = 'Y';
                                    $flowcellSeqlanes[$i]->control_id = $control_id;
                                } else {
                                    $flowcellSeqlanes[$i] = new Seqlanes();
                                    $flowcellSeqlanes[$i]->number = $number;
                                    $flowcellSeqlanes[$i]->flowcell_id = $flowcell_id;
                                    $flowcellSeqlanes[$i]->apply_conc = $apply_conc;
                                    $flowcellSeqlanes[$i]->is_control = 'Y';
                                    $flowcellSeqlanes[$i]->control_id = $control_id;
                                }
                                $new_seqtemplate_name[] = Controls::findFirst($control_id)->name;
                                $i++;
                            }
                        } else if ($is_active == 'N') {
                            $seq_demultiplex_results = SeqDemultiplexResults::findBySeqlaneId($seqlane_id);
                            if (count($seq_demultiplex_results)) {
                                if ($seq_demultiplex_results->delete() == false) {
                                    foreach ($seq_demultiplex_results->getMessages() as $message) {
                                        $this->flashSession->error((string)$message);
                                    }
                                    return false;
                                }
                            }

                            $seqlane = Seqlanes::findFirst($seqlane_id);
                            if ($seqlane) {
                                if ($seqlane->delete() == false) {
                                    foreach ($seqlane->getMessages() as $message) {
                                        $this->flashSession->error((string)$message);
                                    }
                                    return false;
                                }
                                $del_seqlane_name[] = $seqlane->number;
                                $i++;
                            }
                        } else {
                            return false;
                        }
                    }

                    if ($i > 0) {
                        /*
                         * Save $oligobarcodeSchemeOligobarcodes data values.
                         */
                        $flowcell->Seqlanes = $flowcellSeqlanes;
                        if ($flowcell->save() == false) {
                            foreach ($flowcell->getMessages() as $message) {
                                $this->flashSession->error((string)$message);
                            }
                            return false;
                        } else {
                            if (count($new_seqtemplate_name)) {
                                $new_seqtemplate_name_str = implode(",", $new_seqtemplate_name);
                                $this->flashSession->success('Flowcell Seqlanes: ' . $new_seqtemplate_name_str . ' are edited.');
                            }
                            if (count($del_seqlane_name)) {
                                $del_seqlane_name_str = implode(",", $del_seqlane_name);
                                $this->flashSession->success('Flowcell Seqlanes, lane_number: ' . $del_seqlane_name_str . ' are deleted.');
                            }

                        }
                    }
                }
            }
        } else {
            Tag::appendTitle(' | ' . $flowcell->name . ' | Flowcell Seqtemplates.');
            $this->view->setVar('flowcell', $flowcell);

            $flowcell_seqlanes = Seqlanes::find(array(
                "flowcell_id = :flowcell_id:",
                "bind" => array(
                    "flowcell_id" => $flowcell_id
                ),
                "order" => "number ASC"
            ));
            $this->view->setVar('flowcell_seqlanes', $flowcell_seqlanes);
        }
    }


    public
    function showTubeSeqtemplatesAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_MAIN_LAYOUT);
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_AFTER_TEMPLATE);
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                $query = $request->getPost("pick_query", "striptags");
                $flowcell_id = $request->getPost("flowcell_id", "int");

                $flowcell = Flowcells::findFirst($flowcell_id);
                if ($flowcell and $query) {
                    $flowcell_seq_runmode_type_id = $flowcell->seq_runmode_type_id;
                    $flowcell_platform_code = SeqRunmodeTypes::findFirst($flowcell_seq_runmode_type_id)->platform_code;
                    $seqtemplates = $this->modelsManager->createBuilder()
                        ->columns(array(
                            'st.*',
                            'se.*',
                            'sp.*',
                            'COUNT(DISTINCT sl.id) AS sl_count'
                        ))
                        ->addFrom('Seqtemplates', 'st')
                        ->leftJoin('StepEntries', 'se.seqtemplate_id = st.id', 'se')
                        ->leftJoin('Steps', 'sp.id = se.step_id', 'sp')
                        ->leftJoin('Seqlanes', 'sl.seqtemplate_id = st.id', 'sl')
                        ->where("sp.platform_code = :platform_code:", array(
                            "platform_code" => $flowcell_platform_code
                        ))
                        ->andWhere('st.name LIKE :query:', array("query" => '%' . $query . '%'))
                        ->groupBy('st.id, se.id')
                        ->orderBy('st.name ASC')
                        ->getQuery()
                        ->execute();

                    $this->view->setVar('seqtemplates', $seqtemplates);

                    $controls = Controls::find(array(
                        "name LIKE :query: AND platform_code = :platform_code: AND active = 'Y'",
                        "bind" => array(
                            "query" => '%' . $query . '%',
                            "platform_code" => $flowcell_platform_code
                        )
                    ));

                    $this->view->setVar('controls', $controls);
                } else {
                    return false;
                }

            }
        }
    }

}
