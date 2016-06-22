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
                    return $this->flashSession->error('ERROR: Undefined user_id value ' . $user_id . '.');
                }


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
                $user_id = $this->request->getPost('user_id', 'int');
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

                //Custom Filter for username value.
                $filter = new \Phalcon\Filter();
                $filter->add('labname', function ($value) {
                    $value = preg_replace('/[^a-zA-Z0-9\.\-_]/', '', $value);
                    $value = preg_replace('/\.+/', '.', $value);
                    $value = preg_replace('/\.+$/', '', $value);
                    return $value;
                });

                $lab_id = $this->request->getPost('lab_id', 'int');
                $name = $this->request->getPost('name', array('striptags'));
                $name = $filter->sanitize($name, 'labname');
                $department = ($this->request->getPost('department', array('striptags'))) ? $this->request->getPost('department', array('striptags')) : null;
                $zipcode = ($this->request->getPost('zipcode', array('striptags'))) ? $this->request->getPost('zipcode', array('striptags')) : null;
                $address1 = ($this->request->getPost('address1', array('striptags'))) ? $this->request->getPost('address1', array('striptags')) : null;
                $address2 = ($this->request->getPost('address2', array('striptags'))) ? $this->request->getPost('address2', array('striptags')) : null;
                $phone = ($this->request->getPost('phone', array('striptags'))) ? $this->request->getPost('phone', array('striptags')) : null;
                $fax = ($this->request->getPost('fax', array('striptags'))) ? $this->request->getPost('fax', array('striptags')) : null;
                $email = ($this->request->getPost('email', array('email', 'trim'))) ? $this->request->getPost('email', array('email', 'trim')) : null;
                $active = ($this->request->getPost('active', array('striptags'))) ? $this->request->getPost('active', array('striptags')) : null;

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
                        $this->flashSession->success('Lab.：' . $lab->name . ' is created.');
                    } elseif ($lab->active == 'N') {
                        $this->flashSession->success('Lab.：' . $lab->name . ' is change to in-active account.');
                    } else {
                        $this->flashSession->success('Lab.：' . $lab->name . ' record is changed.');
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

                $new_users_id_array = $this->request->getPost('new_users_id_array', array('striptags'));
                $del_users_id_array = $this->request->getPost('del_users_id_array', array('striptags'));

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
                            $this->flashSession->success('Lab. Users：' . $new_users_name_str . ' is added.');
                        }
                        if (count($del_users_name)) {
                            $del_users_name_str = implode(",", $del_users_name);
                            $this->flashSession->success('Lab. Users：' . $del_users_name_str . ' is deleted.');
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
                //Custom Filter for username value.
                $filter = new \Phalcon\Filter();
                $filter->add('projectname', function ($value) {
                    $value = preg_replace('/[^a-zA-Z0-9\.\-_]/', '', $value);
                    $value = preg_replace('/\.+/', '.', $value);
                    $value = preg_replace('/\.+$/', '', $value);
                    return $value;
                });

                $project_id = $this->request->getPost('project_id', 'int');
                $lab_id = $this->request->getPost('lab_id', 'int');
                $name = $this->request->getPost('name', array('striptags'));
                $name = $filter->sanitize($name, 'projectname');
                $pi_user_id = $this->request->getPost('pi_user_id', 'int');
                $project_type_id = $this->request->getPost('project_type_id', 'int');
                $description = ($this->request->getPost('description', array('striptags'))) ? $this->request->getPost('description', array('striptags')) : null;
                $active = ($this->request->getPost('active', array('striptags'))) ? $this->request->getPost('active', array('striptags')) : null;

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
                 * Save user data values.
                 */
                //var_dump($project->toArray());
                if ($project->save() == false) {
                    foreach ($project->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($project_id == -1) {
                        $this->flashSession->success('Project：' . $project->name . ' is created.');
                    } elseif ($project->active == 'N') {
                        $this->flashSession->success('Project：' . $project->name . ' is change to in-active account.');
                    } else {
                        $this->flashSession->success('Project：' . $project->name . ' record is changed.');
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

    public function createPiUsersSelectAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();
                $lab_id = $this->request->getPost('lab_id', 'int');
                $pi_user_id = $this->request->getPost('pi_user_id', 'int');
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

                $new_users_id_array = $this->request->getPost('new_users_id_array', array('striptags'));
                $del_users_id_array = $this->request->getPost('del_users_id_array', array('striptags'));

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
                     * Save LabUser data values.
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
                            $this->flashSession->success('Project Users：' . $new_users_name_str . ' is added.');
                        }
                        if (count($del_users_name)) {
                            $del_users_name_str = implode(",", $del_users_name);
                            $this->flashSession->success('Project Users：' . $del_users_name_str . ' is deleted.');
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
        Tag::appendTitle(' | Steps');
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();
                //Custom Filter for username value.
                $filter = new \Phalcon\Filter();
                $filter->add('stepname', function ($value) {
                    $value = preg_replace('/[^a-zA-Z0-9\.\-_]/', '', $value);
                    $value = preg_replace('/\.+/', '.', $value);
                    $value = preg_replace('/\.+$/', '', $value);
                    return $value;
                });

                $step_id = $this->request->getPost('step_id', 'int');
                $name = $this->request->getPost('name', array('striptags'));
                $name = $filter->sanitize($name, 'stepname');
                $short_name = $this->request->getPost('short_name', array('striptags'));
                $short_name = $filter->sanitize($short_name, 'stepname');
                $step_phase_code = $this->request->getPost('step_phase_code', array('striptags', 'alphanum', 'trim', 'upper'));
                $seq_runmode_type_id = ($this->request->getPost('seq_runmode_type_id', 'int')) ? $this->request->getPost('seq_runmode_type_id', 'int') : null;
                $platform_code = ($this->request->getPost('platform_code', array('striptags', 'alphanum', 'trim', 'upper'))) ? $this->request->getPost('platform_code', array('striptags', 'alphanum', 'trim', 'upper')) : null;
                $nucleotide_type = $this->request->getPost('nucleotide_type', array('striptags', 'alphanum', 'trim', 'upper'));
                $sort_order = $this->request->getPost('sort_order', 'int');
                $active = ($this->request->getPost('active', array('striptags'))) ? $this->request->getPost('active', array('striptags')) : null;

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
                        $this->flashSession->success('Project：' . $step->name . ' is created.');
                    } elseif ($step->active == 'N') {
                        $this->flashSession->success('Project：' . $step->name . ' is change to in-active account.');
                    } else {
                        $this->flashSession->success('Project：' . $step->name . ' record is changed.');
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
        $auth = $this->session->get('auth');
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $this->view->disable();
                //Custom Filter for username value.
                $filter = new \Phalcon\Filter();
                $filter->add('protocolname', function ($value) {
                    $value = preg_replace('/[^a-zA-Z0-9\.\-_]/', '', $value);
                    $value = preg_replace('/\.+/', '.', $value);
                    $value = preg_replace('/\.+$/', '', $value);
                    return $value;
                });

                $protocol_id = $this->request->getPost('protocol_id', 'int');
                $name = $this->request->getPost('name', array('striptags'));
                $name = $filter->sanitize($name, 'protocolname');
                $description = ($this->request->getPost('description', array('striptags'))) ? $this->request->getPost('description', array('striptags')) : null;
                $step_id = $this->request->getPost('step_id', 'int');
                $min_multiplex_number = $this->request->getPost('min_multiplex_number', 'int');
                $max_multiplex_number = $this->request->getPost('max_multiplex_number', 'int');
                $next_step_phase_code = $this->request->getPost('next_step_phase_code', array('striptags'));
                $active = ($this->request->getPost('active', array('striptags'))) ? $this->request->getPost('active', array('striptags')) : null;

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
                 * Save user data values.
                 */
                //var_dump($protocol->toArray());
                if ($protocol->save() == false) {
                    foreach ($protocol->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return false;
                } else {
                    if ($protocol_id == -1) {
                        $this->flashSession->success('Protocol：' . $protocol->name . ' is created.');
                    } elseif ($protocol->active == 'N') {
                        $this->flashSession->success('Protocol：' . $protocol->name . ' is change to in-active account.');
                    } else {
                        $this->flashSession->success('Protocol：' . $protocol->name . ' record is changed.');
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

                $new_oligobarcode_scheme_id_array = $this->request->getPost('new_oligobarcode_scheme_id_array', array('striptags'));
                $del_oligobarcode_scheme_id_array = $this->request->getPost('del_oligobarcode_scheme_id_array', array('striptags'));

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
                     * Save LabUser data values.
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
                            $this->flashSession->success('Oligobarcode Scheme：' . $new_oligobarcode_scheme_name_str . ' is added.');
                        }
                        if (count($del_oligobarcode_scheme_name)) {
                            $del_oligobarcode_scheme_name_str = implode(",", $del_oligobarcode_scheme_name);
                            $this->flashSession->success('Oligobarcode Scheme：' . $del_oligobarcode_scheme_name_str . ' is deleted.');
                        }

                    }
                }
            }
        } else {
            Tag::appendTitle(' | ' . $protocol->name . ' | Lab. Members');
            $this->view->setVar('protocol', $protocol);

            $protocol_oligobarcode_scheme_allows = $protocol->OligobarcodeSchemeAllows;
            $this->view->setVar('protocol_oligobarcode_scheme_allows', $protocol_oligobarcode_scheme_allows);

            $oligobarcode_scheme_id = array();
            foreach ($protocol_oligobarcode_scheme_allows as $oligobarcode_scheme_allow) {
                $oligobarcode_scheme_id[] = $oligobarcode_scheme_allow->oligobarcode_scheme_id;
            }
            /*
             * Create candidate user list whom not be joined OligobarcodeSchemes (!=$oligobarcode_scheme_id)
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


}