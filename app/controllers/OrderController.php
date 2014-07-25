<?php
use Phalcon\Tag, Phalcon\Acl, Phalcon\Forms\Form, Phalcon\Forms\Element\Text;

class OrderController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateAfter('main');
        Tag::setTitle('New Experiment Order');

        if (!$this->session->has('seqlib_undecided')) {
            $this->session->set('seqlib_undecided', (object)array("id" => 0, "name" => "false"));
        }
        if (!$this->session->has('seqrun_undecided')) {
            $this->session->set('seqrun_undecided', (object)array("id" => 0, "name" => "false"));
        }
        parent::initialize();
    }

    public function indexAction()
    {
        // @TODO Show user's order list.
    }

    public function newOrderAction()
    {
        // @TODO Should be filter labs which should have lab_users
        //Set default value from session value
        if ($this->session->has('lab')) {
            Tag::setDefault('lab_id', $this->session->get('lab')->id);
        }
        $this->view->setVar('labs', Labs::find("active = 'Y'"));

        //Set default value from session value
        if ($this->session->has('sample_type')) {
            Tag::setDefault('sample_type_id', $this->session->get('sample_type')->id);
        }
        $this->view->setVar('sampletypes', SampleTypes::find(array(
            "active = 'Y'",
            "order" => "sort_order IS NULL ASC, sort_order ASC"
        )));

        //Set default value from session value
        if ($this->session->has('organism')) {
            Tag::setDefault('organism_id', $this->session->get('organism')->id);
        }
        $this->view->setVar('organisms', Organisms::find(array(
            "active = 'Y'",
            "order" => "sort_order IS NULL ASC, sort_order ASC"
        )));

        //Set dafault for qc_inside
        // @TODO this value should be get from configured value.
        $qc_inside = $this->request->get('qc_inside', 'string', 'true');
        \Phalcon\Tag::setDefault("qc_inside", $qc_inside);
        $this->session->set('qc_inside', (object)array("id" => 0, "name" => $qc_inside));

        //Set default value from session value
        if ($this->session->has('seqlib_undecided')) {
            $this->view->setVar('seqlib_undecided', $this->session->get('seqlib_undecided'));
        } else {
            $this->session->set('seqlib_undecided', (object)array("id" => 0, "name" => "false"));
            $this->view->setVar('seqlib_undecided', $this->session->get('seqlib_undecided'));
        }
        if ($this->session->has('seqrun_undecided')) {
            $this->view->setVar('seqrun_undecided', $this->session->get('seqrun_undecided'));
        } else {
            $this->session->set('seqrun_undecided', (object)array("id" => 0, "name" => "false"));
            $this->view->setVar('seqrun_undecided', $this->session->get('seqrun_undecided'));
        }

        //Set form for project modal
        $form = new Form();
        $this->view->form = $form;
        $form->add(new Text("project_name"));

        //Set project_types for project modal
        $project_types = ProjectTypes::find("active = 'Y'");
        $this->view->setVar('project_types', $project_types);

        //Set sample_property_types for columns of Handsontable.
        $sample_property_types = SamplePropertyTypes::find("active = 'Y'");
        $this->view->setVar('sample_property_types', $sample_property_types);

        //Set sample_property_types_checked session value as pre-selected
        if ($this->session->has('sample_property_types_checked')) {
            $this->view->setVar('sample_property_types_checked', $this->session->get('sample_property_types_checked'));
        }
    }

    public function userSelectListAction($lab_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $lab_id = $this->filter->sanitize($lab_id, array("int"));
                //Get auth to find current user.
                $auth = $this->session->get('auth');
                $this->view->setVar('auth', $auth);

                $phql = "
                    SELECT
                      u.id,
                      u.firstname,
                      u.lastname,
                      CONCAT(u.lastname, ', ', u.firstname) AS name
                    FROM
                      Users u, LabUsers lu
                    WHERE
                      u.id = lu.user_id
                    AND
                      lu.lab_id = :lab_id:
                    AND u.active = 'Y'
                    ORDER BY u.name";

                $users = $this->modelsManager->executeQuery($phql, array(
                    'lab_id' => $lab_id
                ));

                //Set default value from session value
                if ($this->session->has('pi_user')) {
                    Tag::setDefault('pi_user_id', $this->session->get('pi_user')->id);
                } else {
                    //Set default selected pi_user_id with session's user.
                    Tag::setDefault('pi_user_id', $auth['id']);
                }

                echo '<label for="pi_user_id" class="control-label">PI </label>';
                echo Tag::selectStatic(
                    array(
                        'pi_user_id',
                        $users,
                        'using' => ['id', 'name'],
                        'class' => 'form-control input-sm'
                    )
                );

            }
        }
    }

    public function projectSelectListAction($pi_user_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $pi_user_id = $this->filter->sanitize($pi_user_id, array("int"));

                $projects = Projects::find(array(
                    "pi_user_id = :pi_user_id:",
                    'bind' => array(
                        'pi_user_id' => $pi_user_id
                    )
                ));

                //Set default value from session value
                if ($this->session->has('project')) {
                    Tag::setDefault('project_id', $this->session->get('project')->id);
                    //var_dump($this->session->get('project')->name);
                }

                $emptyText = (!$projects->getFirst()) ? 'Please, add first project from "+" button' : 'Please, choose Project...';
                echo '<label for="project_id" class="control-label pull-left">Project&nbsp;&nbsp;</label>';
                echo '<span></span>';
                echo '<button type="button" class="btn btn-default btn-xs" data-toggle="modal" data-target="#modal-project">';
                echo '<span class="glyphicon glyphicon-plus"></span>';
                echo '</button>';
                echo Tag::selectStatic(
                    array(
                        'project_id',
                        $projects,
                        'using' => ['id', 'name'],
                        'useEmpty' => true,
                        'emptyText' => $emptyText,
                        'emptyValue' => '@',
                        'class' => 'form-control input-sm'
                    )
                );
            }
        }
    }

    public function stepSelectListAction($sample_type_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                //return disabled select list when upper level select list has been reset.
                if ($sample_type_id === '@') {
                    echo '<label for="step_id" class="control-label">Experiment Step</label>';
                    echo '<select id="step_id" class="form-control input-sm" disabled>';
                    echo '<option value="@">Sample Type is necessary...</option>';
                    echo '</select>';
                    return;
                }

                $sample_type_id = $this->filter->sanitize($sample_type_id, array("int"));

                $sample_types = SampleTypes::findFirst($sample_type_id);

                $steps = $sample_types->getSteps(array(
                    "step_phase_code = 'PREP' AND active = 'Y'",
                    'order' => "sort_order IS NULL ASC, sort_order ASC"
                ));

                //Set default value from session value
                if ($this->session->has('step')) {
                    Tag::setDefault('step_id', $this->session->get('step')->id);
                }

                $emptyText = (!$steps->getFirst()) ? 'Please, add first Experiment' : 'Please, choose Experiment...';
                echo '<label for="step_id" class="control-label">Experiment Step</label>';
                echo Tag::selectStatic(
                    array(
                        'step_id',
                        $steps,
                        'using' => ['id', 'name'],
                        'useEmpty' => true,
                        'emptyText' => $emptyText,
                        'emptyValue' => '@',
                        'class' => 'form-control input-sm'
                    )
                );
            }

        }
    }

    public function protocolSelectListAction($step_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                //return disabled select list when upper level select list has been reset.
                if ($step_id === '@') {
                    echo '<label for="protocol_id" class="control-label">Protocol</label>';
                    echo '<select id="protocol_id" class="form-control input-sm" disabled>';
                    echo '<option value="@">Experiment Step is necessary...</option>';
                    echo '</select>';
                    return;
                }

                $step_id = $this->filter->sanitize($step_id, array("int"));

                $protocols = Protocols::find(array(
                    "step_id = :step_id: AND active = 'Y'",
                    'bind' => array(
                        'step_id' => $step_id
                    )
                ));

                //Set default value from session value
                if ($this->session->has('protocol')) {
                    Tag::setDefault('protocol_id', $this->session->get('protocol')->id);
                }

                $emptyText = (!$protocols->getFirst()) ? 'Please, add first Protocol' : 'Please, choose Protocol...';
                echo '<label for="protocol_id" class="control-label">Protocol</label>';
                echo Tag::selectStatic(
                    array(
                        'protocol_id',
                        $protocols,
                        'using' => ['id', 'name'],
                        'useEmpty' => true,
                        'emptyText' => $emptyText,
                        'emptyValue' => '@',
                        'class' => 'form-control input-sm'
                    )
                );

                // @TODO Add select list to input min/max_multiplex_number
            }
        }
    }

    public function instrumentTypeSelectListAction($step_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                //return disabled select list when upper level select list has been reset.
                if ($step_id === '@') {
                    echo '<label for="instrument_type">Instrument Type</label>';
                    echo '<select id="instrument_type" class="form-control input-sm" disabled>';
                    echo '<option value="@">Experiment Step necessary...</option>';
                    echo '</select>';
                    return;
                }

                $step_id = $this->filter->sanitize($step_id, array("int"));
                $steps = Steps::findFirst($step_id);

                //Build instrument_type_select
                $instrument_types = $steps->getInstrumentTypes(array(
                    "active = 'Y'",
                    "order" => "sort_order IS NULL ASC, sort_order ASC"
                ));

                //Set default value from session value
                if ($this->session->has('instrument_type')) {
                    Tag::setDefault('instrument_type', $this->session->get('instrument_type')->id);
                }

                $emptyText = (!$instrument_types->getFirst()) ? 'Please, configure instrument type before' : 'Please, choose Instrument Type...';
                echo '<label for="instrument_type">Instrument Type</label>';
                echo Tag::selectStatic(
                    array(
                        'instrument_type',
                        $instrument_types,
                        'using' => ['id', 'name'],
                        'useEmpty' => true,
                        'emptyText' => $emptyText,
                        'emptyValue' => '@',
                        'class' => 'form-control input-sm'
                    )
                );
            }
        }
    }


    public function seqRunmodeTypesSelectListAction()
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $instrument_type_id = $this->request->getPost('instrument_type_id', 'int');
                $seq_run_type_schemes = SeqRunTypeSchemes::find(array(
                    "instrument_type_id = :instrument_type_id: AND active = 'Y'",
                    'bind' => array(
                        'instrument_type_id' => $instrument_type_id
                    )
                ));


                $seq_runmode_types_uniq = array(); // @TODO Could not use DISTINCT
                echo '<label for="seq_runmode_type">Run Mode</label><br>';
                foreach ($seq_run_type_schemes as $seq_run_type_scheme) {
                    //Build seq_runmode_select
                    $seq_runmode_type = $seq_run_type_scheme->getSeqRunmodeTypes(array(
                        "active = 'Y'",
                        "order" => "sort_order IS NULL ASC, sort_order ASC"
                    ));
                    if (!empty($seq_runmode_type) && !isset($seq_runmode_types_uniq[$seq_runmode_type->id])) {
                        if ($this->session->has('seq_runmode_type') && $seq_runmode_type->id == $this->session->get('seq_runmode_type')->id) {
                            echo '<label class="radio-inline">';
                            echo Tag::radioField(array(
                                "seq_runmode_type_id_" . $seq_runmode_type->id,
                                "name" => "seq_runmode_type",
                                "value" => $seq_runmode_type->id,
                                "checked" => "checked"
                            ));
                            echo $seq_runmode_type->name;
                            echo '</label>';
                        } else {
                            echo '<label class="radio-inline">';
                            echo Tag::radioField(array(
                                "seq_runmode_type_id_" . $seq_runmode_type->id,
                                "name" => "seq_runmode_type",
                                "value" => $seq_runmode_type->id
                            ));
                            echo $seq_runmode_type->name;
                            echo '</label>';
                        }
                        $seq_runmode_types_uniq[$seq_runmode_type->id] = true;
                    }
                }
            }
        }
    }

    public function seqRunreadTypesSelectListAction()
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $instrument_type_id = $this->request->getPost('instrument_type_id', 'int');
                $seq_runmode_type_id = $this->request->getPost('seq_runmode_type_id', 'int');
                $slot = $this->request->getPost('slot', 'striptags');
                $seq_run_type_schemes = SeqRunTypeSchemes::find(array(
                    "instrument_type_id = :instrument_type_id: AND seq_runmode_type_id = :seq_runmode_type_id: AND active = 'Y'",
                    'bind' => array(
                        'instrument_type_id' => $instrument_type_id,
                        'seq_runmode_type_id' => $seq_runmode_type_id
                    )
                ));


                if (empty($slot)) {
                    $seq_runread_type_id_attr = 'seq_runread_type';
                } else {
                    $seq_runread_type_id_attr = 'seq_runread_type_' . $slot;
                }
                $seq_runread_types_uniq = array(); // @TODO Could not use DISTINCT
                echo '<label for="' . $seq_runread_type_id_attr . '">Read Type</label><br>';
                foreach ($seq_run_type_schemes as $seq_run_type_scheme) {
                    //Build seq_runmread_select
                    $seq_runread_type = $seq_run_type_scheme->getSeqRunreadTypes(array(
                        "active = 'Y'",
                        "order" => "sort_order IS NULL ASC, sort_order ASC"
                    ));
                    if (!empty($seq_runread_type) && !isset($seq_runread_types_uniq[$seq_runread_type->id])) {
                        if ($this->session->has($seq_runread_type_id_attr) && $seq_runread_type->id == $this->session->get($seq_runread_type_id_attr)->id) {
                            echo '<label class="radio-inline">';
                            echo Tag::radioField(array(
                                "seq_runread_type_id_" . $seq_runread_type->id,
                                "name" => $seq_runread_type_id_attr,
                                "value" => $seq_runread_type->id,
                                'checked' => 'checked'
                            ));
                            echo $seq_runread_type->name;
                            echo '</label>';
                        } else {
                            echo '<label class="radio-inline">';
                            echo Tag::radioField(array(
                                "seq_runread_type_id_" . $seq_runread_type->id,
                                "name" => $seq_runread_type_id_attr,
                                "value" => $seq_runread_type->id
                            ));
                            echo $seq_runread_type->name;
                            echo '</label>';
                        }
                        $seq_runread_types_uniq[$seq_runread_type->id] = true;
                    }
                }
            }
        }
    }

    public function seqRuncycleTypesSelectListAction()
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $instrument_type_id = $this->request->getPost('instrument_type_id', 'int');
                $seq_runmode_type_id = $this->request->getPost('seq_runmode_type_id', 'int');
                $seq_runread_type_id = $this->request->getPost('seq_runread_type_id', 'int');
                $slot = $this->request->getPost('slot', 'striptags');
                $seq_run_type_schemes = SeqRunTypeSchemes::find(array(
                    "instrument_type_id = :instrument_type_id: AND seq_runmode_type_id = :seq_runmode_type_id: AND seq_runread_type_id = :seq_runread_type_id: AND active = 'Y'",
                    'bind' => array(
                        'instrument_type_id' => $instrument_type_id,
                        'seq_runmode_type_id' => $seq_runmode_type_id,
                        'seq_runread_type_id' => $seq_runread_type_id
                    )
                ));

                if (empty($slot)) {
                    $seq_runcycle_type_id_attr = 'seq_runcycle_type';
                } else {
                    $seq_runcycle_type_id_attr = 'seq_runcycle_type_' . $slot;
                }
                $seq_runcycle_types_uniq = array(); // @TODO Could not use DISTINCT
                echo '<label for="' . $seq_runcycle_type_id_attr . '">Read Cycle</label><br>';
                foreach ($seq_run_type_schemes as $seq_run_type_scheme) {
                    //Build seq_runcycle_select
                    $seq_runcycle_type = $seq_run_type_scheme->getSeqRuncycleTypes(array(
                        "active = 'Y'",
                        "order" => "sort_order IS NULL ASC, sort_order ASC"
                    ));
                    if (!empty($seq_runcycle_type) && !isset($seq_runcycle_types_uniq[$seq_runcycle_type->id])) {
                        if ($this->session->has($seq_runcycle_type_id_attr) && $seq_runcycle_type->id == $this->session->get($seq_runcycle_type_id_attr)->id) {
                            echo '<label class="radio-inline">';
                            echo Tag::radioField(array(
                                "seq_runcycle_type_id_" . $seq_runcycle_type->id,
                                "name" => $seq_runcycle_type_id_attr,
                                "value" => $seq_runcycle_type->id,
                                'checked' => 'checked'
                            ));
                            echo $seq_runcycle_type->name;
                            echo '</label>';
                        } else {
                            echo '<label class="radio-inline">';
                            echo Tag::radioField(array(
                                "seq_runcycle_type_id_" . $seq_runcycle_type->id,
                                "name" => $seq_runcycle_type_id_attr,
                                "value" => $seq_runcycle_type->id
                            ));
                            echo $seq_runcycle_type->name;
                            echo '</label>';
                        }
                        $seq_runcycle_types_uniq[$seq_runcycle_type->id] = true;
                    }
                }
            }
        }
    }

    //public function orderSetSessionAction($column, $id, $name)
    public function orderSetSessionAction()
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                //$column = $this->filter->sanitize($column, array("string"));
                //$id = $this->filter->sanitize($id, array("int"));
                //$name = $this->filter->sanitize($name, array("string"));

                $column = $this->request->getPost('column', 'string');
                $id = $this->request->getPost('id', 'int');
                $name = $this->request->getPost('name', 'string');

                if (is_null($column)) {
                    $this->flashSession->error("Model: " . $column . ", id: " . $id . ", name: " . $name);
                    return;
                } else if (!is_numeric($id) || empty($name)) {
                    $this->session->remove($column);
                    return;
                } else {
                    $data = (object)array("id" => $id, "name" => $name);
                    $this->session->set($column, $data);
                    //var_dump($this->session->get($column));
                }

            }
        }
    }

    public function confirmAction()
    {

        $warning = 0; // @TODO How to know flashSession is exist or not?

        if (!$this->session->has('lab')) {
            $this->flashSession->warning("Please select Lab");
            $warning++;
        } else {
            $this->view->setVar('lab', $this->session->get('lab'));
        }

        if (!$this->session->has('pi_user')) {
            $this->flashSession->warning("Please select PI");
            $warning++;
        } else {
            $this->view->setVar('pi_user', $this->session->get('pi_user'));
        }

        if (!$this->session->has('project')) {
            $this->flashSession->warning("Please select Project");
            $warning++;
        } else {
            $this->view->setVar('project', $this->session->get('project'));
        }

        if (!$this->session->has('sample_type')) {
            $this->flashSession->warning("Please select Sample Type");
            $warning++;
        } else {
            $this->view->setVar('sample_type', $this->session->get('sample_type'));
        }

        if (!$this->session->has('organism')) {
            $this->flashSession->warning("Please select Organism");
            $warning++;
        } else {
            $this->view->setVar('organism', $this->session->get('organism'));
        }

        $seqlib_undecided = $this->session->get('seqlib_undecided');
        $this->view->setVar('seqlib_undecided', $seqlib_undecided);
        if ($seqlib_undecided->name === "false") {
            if (!$this->session->has('step')) {
                $this->flashSession->warning("Please select Experiment Step");
                $warning++;
            } else {
                $this->view->setVar('step', $this->session->get('step'));
            }

            if (!$this->session->has('protocol')) {
                $this->flashSession->warning("Please select Experiment Protocol");
                $warning++;
            } else {
                $this->view->setVar('protocol', $this->session->get('protocol'));
            }

            if (!$this->session->has('samples_per_seqtemplate')) {
                $this->view->setVar('samples_per_seqtemplate', '(Undefined)');
            } else {
                $this->view->setVar('samples_per_seqtemplate', $this->session->get('samples_per_seqtemplate'));
            }
        }


        $seqrun_undecided = $this->session->get('seqrun_undecided');
        $this->view->setVar('seqrun_undecided', $seqrun_undecided);
        if ($seqrun_undecided->name === "false") {
            if (!$this->session->has('instrument_type')) {
                $this->flashSession->warning("Please select Instrument Type");
                $warning++;
            } else {
                $this->view->setVar('instrument_type', $this->session->get('instrument_type'));
            }

            if (!$this->session->has('seq_runmode_type')) {
                $this->flashSession->warning("Please select Seq Run Mode");
                $warning++;
            } else {
                $this->view->setVar('seq_runmode_type', $this->session->get('seq_runmode_type'));
            }

            if (!$this->session->has('seq_runread_type')) {
                $this->flashSession->warning("Please select Seq Read Type");
                $warning++;
            } else {
                $this->view->setVar('seq_runread_type', $this->session->get('seq_runread_type'));
            }

            if (!$this->session->has('seq_runcycle_type')) {
                $this->flashSession->warning("Please select Seq Read Type");
                $warning++;
            } else {
                $this->view->setVar('seq_runcycle_type', $this->session->get('seq_runcycle_type'));
            }

            if (!$this->session->has('lanes_per_seqtemplate')) {
                $this->view->setVar('lanes_per_seqtemplate', '(Undefined)');
            } else {
                $this->view->setVar('lanes_per_seqtemplate', $this->session->get('lanes_per_seqtemplate'));
            }
        }

        if (!$this->session->has('sample')) {
            $this->flashSession->warning("Please input Sample information");
            $warning++;
        } else {
            $sample_data_str = str_replace('&#34;', '"', $this->session->get('sample')->name);
            $sample_data = json_decode($sample_data_str, false);
            //var_dump($sample_data);
            $name = array();
            $name_exception = 0;
            $count = 0;
            foreach ($sample_data as $row) {
                $count++;
                if (empty($row->name)) {
                    $this->flashSession->warning("Please input Sample Name at line " . $count);
                    $warning++;
                    $name_exception++;
                }
                $name[] = $row->name;
            }
            $this->view->setVar('sample_count', $count);

            if ($name_exception < 1) {
                $name_count = array_count_values($name);
                //var_dump(array_count_values($name));
                $duplicated = 0;
                foreach ($name_count as $name => $count) {
                    if ($count > 1) {
                        $this->flashSession->warning("Sample Name \"" . $name . "\" is duplicated " . $count . " times. Please input unique Sample Name.");
                        $warning++;
                        $duplicated++;
                    }
                }

                if ($duplicated > 0) {
                    return $this->response->redirect("order/newOrder");
                }
            } else {
                return $this->response->redirect("order/newOrder");
            }

        }

        //var_dump($warning);
        if ($warning > 0) {
            $this->flashSession->error($warning . " error(s).");
            return $this->response->redirect("order/newOrder");
        }

    }

    public function loadSessionSampleDataAction()
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                if (!$this->session->has('sample')) {
                    return;
                } else {
                    $sample_data_str = str_replace('&#34;', '"', $this->session->get('sample')->name);
                    echo $sample_data_str;
                }
            }
        }
    }

    public function saveProjectAction()
    {
        if (!$this->request->isPost()) {
            return $this->forward("order/newOrder");
        }
        $projects = new Projects();
        $projects->name = $this->request->getPost("project_name", "striptags");
        $projects->project_type_id = $this->request->getPost("project_type_id", "striptags");
        $projects->lab_id = $this->session->get('lab')->id;
        $projects->user_id = $this->session->get('auth')['id'];
        $projects->pi_user_id = $this->session->get('pi_user')->id;
        //$projects->created_at = '2014-02-07';

        $prev_projects = Projects::find(array(
            "name = :name: AND pi_user_id = :pi_user_id:",
            'bind' => array(
                'name' => $projects->name,
                'pi_user_id' => $projects->pi_user_id
            )
        ));

        if (!$prev_projects->count() > 0) {
            if (!$projects->save()) {
                foreach ($projects->getMessages() as $message) {
                    $this->flashSession->error((string)$message);
                }
            } else {
                $this->flashSession->notice("Project " . $projects->name . " has been recorded.");
                $data = (object)array("id" => $projects->id, "name" => $projects->name);
                $this->session->set('project', $data);
            }
        } else {
            $this->flashSession->error($this->session->get('auth')['name'] . " already has Project " . $projects->name);
        }

        return $this->response->redirect("order/newOrder");

    }

    public function checkoutAction()
    {
        /*
         * Set data for Requests
         */
        $requests = new Requests();
        $requests->project_id = $this->session->get('project')->id;
        $requests->lab_id = $this->session->get('lab')->id;
        $requests->user_id = $this->session->get('auth')['id'];
        if ($this->session->has('samples_per_seqtemplate')) {
            $requests->samples_per_seqtemplate = $this->session->get('samples_per_seqtemplate')->name;
        }
        if ($this->session->has('lanes_per_seqtemplate')) {
            $requests->lanes_per_seqtemplate = $this->session->get('lanes_per_seqtemplate')->name;
        }

        if ($this->session->get('seqlib_undecided')->name === "false") {
            //Set property of Experiment Step (for PREP)
            $step_lib = Steps::FindFirst($this->session->get('step')->id);
        }
        /*
         * Set Seq Run properties when seqrun is decided.
         */
        if ($this->session->get('seqrun_undecided')->name === "false") {
            $instrument_type = $this->session->get('instrument_type');
            $seq_runmode_type = $this->session->get('seq_runmode_type');
            $seq_runread_type = $this->session->get('seq_runread_type');
            $seq_runcycle_type = $this->session->get('seq_runcycle_type');
            $seq_run_type_scheme = SeqRunTypeSchemes::findFirst(array(
                "instrument_type_id = :instrument_type_id:
                    AND seq_runmode_type_id = :seq_runmode_type_id:
                    AND seq_runread_type_id = :seq_runread_type_id:
                    AND seq_runcycle_type_id = :seq_runcycle_type_id:
                    AND active = 'Y'",
                'bind' => array(
                    'instrument_type_id' => $instrument_type->id,
                    'seq_runmode_type_id' => $seq_runmode_type->id,
                    'seq_runread_type_id' => $seq_runread_type->id,
                    'seq_runcycle_type_id' => $seq_runcycle_type->id
                )
            ));

            if ($seq_run_type_scheme) {
                $requests->seq_run_type_scheme_id = $seq_run_type_scheme->id;
            } else {
                $this->flashSession->error("Couldn't get seq_run_type_schemes from " . $instrument_type->name . ", " . $seq_runmode_type->name . ", " . $seq_runread_type->name . ", " . $seq_runcycle_type->name);
            }
        }


        /*
         * Set data for Samples, Seqlibs and StepEntries
         */
        //Get sample data from session which generated by handsontable
        $sample_data_str = str_replace('&#34;', '"', $this->session->get('sample')->name);
        $sample_data_arr = json_decode($sample_data_str, false);
        //var_dump($sample_datas);

        //Set property for QC step to StepEntries
        $qc_inside_val = $this->session->get('qc_inside')->name;

        //Set property of Experiment Step (for QC)
        $sample_type = SampleTypes::findFirst("id = " . $this->session->get('sample_type')->id);
        $step_qc = Steps::findFirst("nucleotide_type = '" . $sample_type->nucleotide_type . "' AND step_phase_code = 'QC'");

        //Set sample_property_types
        $sample_property_types = SamplePropertyTypes::find("active = 'Y'");

        $samples = array();
        $qc_step_entries = array();
        $seqlibs = array();
        $seqlib_step_entries = array();
        $sample_property_entries = array();

        $i = 0;
        foreach ($sample_data_arr as $sample_data) {
            //Set data to Samples
            $samples[$i] = new Samples();
            $samples[$i]->name = $sample_data->name;
            //$samples[$i]->request_id = $requests->id; //It's not necessary because of hasMany relation.
            $samples[$i]->project_id = $requests->project_id;
            $samples[$i]->sample_type_id = $this->session->get('sample_type')->id;
            $samples[$i]->organism_id = $this->session->get('organism')->id;
            $samples[$i]->qual_concentration = $sample_data->qual_concentration;
            $samples[$i]->qual_od260280 = $sample_data->qual_od260280;
            $samples[$i]->qual_od260230 = $sample_data->qual_od260230;
            $samples[$i]->qual_RIN = $sample_data->qual_RIN;
            $samples[$i]->qual_fragmentsize = $sample_data->qual_fragmentsize;
            $samples[$i]->qual_nanodrop_conc = $sample_data->qual_nanodrop_conc;
            $samples[$i]->qual_volume = $sample_data->qual_volume;
            $samples[$i]->qual_amount = $sample_data->qual_amount;
            $samples[$i]->qual_date = $sample_data->qual_date;

            if ($qc_inside_val === "true") {
                //Set QC step to StepEntries
                $qc_step_entries[0] = new StepEntries();
                $qc_step_entries[0]->step_id = $step_qc->id;
                $qc_step_entries[0]->step_phase_code = $step_qc->step_phase_code;
                $qc_step_entries[0]->user_id = $this->session->get('auth')['id'];

            }
            if ($this->session->get('seqlib_undecided')->name === "false") {
                //Set PREP step to StepEntries
                $seqlib_step_entries[0] = new StepEntries();
                $seqlib_step_entries[0]->step_id = $step_lib->id;
                $seqlib_step_entries[0]->step_phase_code = $step_lib->step_phase_code;
                $seqlib_step_entries[0]->protocol_id = $this->session->get('protocol')->id;
                $seqlib_step_entries[0]->user_id = $this->session->get('auth')['id'];

                //Set data to Seqlibs
                $seqlibs[0] = new Seqlibs();
                $seqlibs[0]->name = $sample_data->name . '_' . date("Ymd");
                $seqlibs[0]->project_id = $requests->project_id;
                $seqlibs[0]->protocol_id = $this->session->get('protocol')->id;

                // Tied (seqlib) StepEntries to Seqlibs
                $seqlibs[0]->StepEntries = $seqlib_step_entries[0];
            }

            $j = 0;
            foreach ($sample_property_types as $sample_property_type) {
                $sample_property_type_id = $sample_property_type->id;
                if (isset($sample_data->sample_property_types->$sample_property_type_id)) {
                    $sample_property_entries[$j] = new SamplePropertyEntries();
                    $sample_property_entries[$j]->sample_property_type_id = $sample_property_type_id;
                    $sample_property_entries[$j]->value = $sample_data->sample_property_types->$sample_property_type_id;
                    $j++;
                }
            }

            // Tied StepEntries and Seqlibs to Samples with has-many relation (They will be saved with Samples, and Samples will be saved with Requests)
            $samples[$i]->StepEntries = $qc_step_entries;
            $samples[$i]->Seqlibs = $seqlibs;
            $samples[$i]->SamplePropertyEntries = $sample_property_entries;
            $i++;
        }

        /*
         * Saving Requests and its related Samples in a has-many relation
         */
        $requests->Samples = $samples;

        if (!$requests->save()) {
            foreach ($requests->getMessages() as $message) {
                $this->flashSession->error((string)$message);
            }
        } else {
            $this->flashSession->notice("Request " . $requests->id . " has been recorded.");
            // Remove session which has been saved.
            $this->session->remove('lab');
            $this->session->remove('pi_user');
            $this->session->remove('project');
            $this->session->remove('sample_type');
            $this->session->remove('organism');
            $this->session->remove('qc_inside');
            $this->session->remove('sample');
            $this->session->remove('sample_property_types_checked');
            $this->session->remove('seqlib_undecided');
            $this->session->remove('step');
            $this->session->remove('protocol');
            $this->session->remove('samples_per_seqtemplate');
            $this->session->remove('seqrun_undecided');
            $this->session->remove('instrument_type');
            $this->session->remove('seq_runmode_type');
            $this->session->remove('seq_runread_type');
            $this->session->remove('seq_runcycle_type');
            $this->session->remove('lanes_per_seqtemplate');
        }

        // Input into step_entries

        // @TODO Remove session which has been saved.
        return $this->response->redirect("order/index");
    }

}

