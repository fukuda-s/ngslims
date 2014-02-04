<?php
use Phalcon\Tag, Phalcon\Acl;

class OrderController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateAfter('main');
        Tag::setTitle('New Experiment Order');
        parent::initialize();
    }

    public function indexAction()
    {
        return $this->forward("order/newOrder");
    }

    public function newOrderAction()
    {
        // @TODO Should be filter labs which should have lab_users
        //Set default value from session value
        if ($this->session->has('lab')) {
            $this->tag->setDefault('lab_id', $this->session->get('lab')->id);
        }
        $this->view->setVar('labs', Labs::find("active = 'Y'"));

        //Set default value from session value
        if ($this->session->has('sample_type')) {
            $this->tag->setDefault('sample_type_id', $this->session->get('sample_type')->id);
        }
        $this->view->setVar('sampletypes', SampleTypes::find(array(
            "active = 'Y'",
            "order" => "sort_order IS NULL ASC, sort_order ASC"
        )));

        //Set default value from session value
        if ($this->session->has('organism')) {
            $this->tag->setDefault('organism_id', $this->session->get('organism')->id);
        }
        $this->view->setVar('organisms', Organisms::find(array(
            "active = 'Y'",
            "order" => "sort_order IS NULL ASC, sort_order ASC"
        )));

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
            $this->view->setVar('seqrun_undecided', $this->session->get('seqrun_undecidedd'));
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
                      u.name
                    FROM
                      Users u, LabUsers lu
                    WHERE
                      u.id = lu.user_id
                    AND
                      lu.lab_id = :lab_id:
                    AND u.active = 'Y'
                    ORDER BY u.name";

                $users = $this->modelsManager->executeQuery($phql, array(
                    'lab_id' => $lab_id,
                ));


                //Set default value from session value
                if ($this->session->has('pi_user')) {
                    $this->tag->setDefault('pi_user_id', $this->session->get('pi_user')->id);
                } else {
                    //Set default selected pi_user_id with session's user.
                    $this->tag->setDefault('pi_user_id', $auth['id']);
                }

                echo '<label for="pi_user_id" class="control-label">PI </label>';
                echo $this->tag->selectStatic(
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
                    $this->tag->setDefault('project_id', $this->session->get('project')->id);
                }

                $emptyText = (!$projects->getFirst()) ? 'Please, add first project from "+" button' : 'Please, choose Project...';
                echo '<label for="project_id" class="control-label pull-left">Project&nbsp;&nbsp;</label>';
                echo '<span></span>';
                echo '<button type="button" class="btn btn-default btn-xs" data-toggle="modal" data-target="#modal-project">';
                echo '<span class="glyphicon glyphicon-plus"></span>';
                echo '</button>';
                echo $this->tag->selectStatic(
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
                    "step_phase_code = 'PREP'",
                    "active = 'Y'",
                    "order" => "sort_order IS NULL ASC, sort_order ASC"
                ));

                //Set default value from session value
                if ($this->session->has('step')) {
                    $this->tag->setDefault('step_id', $this->session->get('step')->id);
                }

                $emptyText = (!$steps->getFirst()) ? 'Please, add first Experiment' : 'Please, choose Experiment...';
                echo '<label for="step_id" class="control-label">Experiment Step</label>';
                echo $this->tag->selectStatic(
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
                    "step_id = :step_id:",
                    "active = 'Y'",
                    'bind' => array(
                        'step_id' => $step_id
                    )
                ));

                //Set default value from session value
                if ($this->session->has('protocol')) {
                    $this->tag->setDefault('protocol_id', $this->session->get('protocol')->id);
                }

                $emptyText = (!$protocols->getFirst()) ? 'Please, add first Protocol' : 'Please, choose Protocol...';
                echo '<label for="protocol_id" class="control-label">Protocol</label>';
                echo $this->tag->selectStatic(
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
                    echo '<label for="instrument_type_id">Instrument Type</label>';
                    echo '<select id="instrument_type_id" class="form-control input-sm" disabled>';
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
                    $this->tag->setDefault('instrument_type_id', $this->session->get('instrument_type')->id);
                }

                $emptyText = (!$instrument_types->getFirst()) ? 'Please, configure instrument type before' : 'Please, choose Instrument Type...';
                echo '<label for="instrument_type_id">Instrument Type</label>';
                echo $this->tag->selectStatic(
                    array(
                        'instrument_type_id',
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

    public function seqRunTypeSelectListAction($instrument_type_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $instrument_type_id = $this->filter->sanitize($instrument_type_id, array("int"));
                $instrumentTypes = InstrumentTypes::findFirst($instrument_type_id);

                //Build seq_runmode_select
                $seq_runmode_types = $instrumentTypes->getSeqRunmodeTypes(array(
                    "SeqRunmodeTypes.active = 'Y'",
                    "order" => "sort_order IS NULL ASC, sort_order ASC"
                ));

                $seq_runmode_types_uniq = array(); // @TODO Could not use DISTINCT
                echo '<div id="seq_runmode_type_select" class="form-group">';
                echo '<label for="seq_runmode_type_id">Run Mode</label><br>';
                foreach ($seq_runmode_types as $seq_runmode_type) {
                    if (!isset($seq_runmode_types_uniq[$seq_runmode_type->id])) {
                        echo '<label class="radio-inline">';
                        echo $this->tag->radioField(array(
                            "seq_runmode_type_id_" . $seq_runmode_type->id,
                            "name" => "seq_runmode_type_id",
                            "value" => $seq_runmode_type->id
                        ));
                        echo $seq_runmode_type->name;
                        echo '</label>';
                        $seq_runmode_types_uniq[$seq_runmode_type->id] = true;
                    }
                }
                echo '</div>';

                //Build seq_runread_select
                $seq_runread_types = $instrumentTypes->getSeqRunreadTypes(array(
                    "SeqRunreadTypes.active = 'Y'",
                    "order" => "sort_order IS NULL ASC, sort_order ASC"
                ));

                $seq_runread_types_uniq = array(); // @TODO Could not use DISTINCT
                echo '<div id="seq_runread_type_select" class="form-group">';
                echo '<label for="seq_runread_type_id">Read Type</label><br>';
                foreach ($seq_runread_types as $seq_runread_type) {
                    if (!isset($seq_runread_types_uniq[$seq_runread_type->id])) {
                        echo '<label class="radio-inline">';
                        echo $this->tag->radioField(array(
                            "seq_runread_type_id_" . $seq_runread_type->id,
                            "name" => "seq_runread_type_id",
                            "value" => $seq_runread_type->id
                        ));
                        echo $seq_runread_type->name;
                        echo '</label>';
                        $seq_runread_types_uniq[$seq_runread_type->id] = true;
                    }
                }
                echo '</div>';


                //Build seq_runcycle_select
                $seq_runcycle_types = $instrumentTypes->getSeqRuncycleTypes(array(
                    "SeqRuncycleTypes.active = 'Y'",
                    "order" => "sort_order IS NULL ASC, sort_order ASC"
                ));

                $seq_runcycle_types_uniq = array(); // @TODO Could not use DISTINCT
                echo '<div id="seq_runcycle_type_select" class="form-group">';
                echo '<label for="seq_runcycle_type_id">Read Cycle</label><br>';
                foreach ($seq_runcycle_types as $seq_runcycle_type) {
                    if (!isset($seq_runcycle_types_uniq[$seq_runcycle_type->id])) {
                        echo '<label class="radio-inline">';
                        echo $this->tag->radioField(array(
                            "seq_runcycle_type_id_" . $seq_runcycle_type->id,
                            "name" => "seq_runcycle_type_id",
                            "value" => $seq_runcycle_type->id
                        ));
                        echo $seq_runcycle_type->name;
                        echo '</label>';
                        $seq_runcycle_types_uniq[$seq_runcycle_type->id] = true;
                    }
                }
                echo '</div>';
            }
        }
    }

    public function orderSetSessionAction($column, $id, $name)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $column = $this->filter->sanitize($column, array("string"));
                $id = $this->filter->sanitize($id, array("int"));
                $name = $this->filter->sanitize($name, array("string"));

                if (is_null($column) || is_null($id) || is_null($name)) {
                    $this->flashSession->error("Model: " . $column . ", id: " . $id . ", name: " . $name);
                    return;
                } else {
                    $data = (object)array("id" => $id, "name" => $name);
                    $this->session->set($column, $data);
                    $this->flashSession->error(var_dump($this->session->get($column)));
                }

            }
        }
    }

    public function confirmAction()
    {
        if (!$this->session->has('lab')) {
            $this->flashSession->error("Please select Lab");
            return $this->response->redirect("order/newOrder");
        } else {
            $this->view->setVar('lab', $this->session->get('lab'));
        }

        if (!$this->session->has('pi_user')) {
            $this->flashSession->warning("Please select PI");
            return $this->response->redirect("order/newOrder");
        } else {
            $this->view->setVar('pi_user', $this->session->get('pi_user'));
        }

        if (!$this->session->has('project')) {
            $this->flashSession->warning("Please select Project");
            return $this->response->redirect("order/newOrder");
        } else {
            $this->view->setVar('project', $this->session->get('project'));
        }

        if (!$this->session->has('sample_type')) {
            $this->flashSession->warning("Please select Sample Type");
            return $this->response->redirect("order/newOrder");
        } else {
            $this->view->setVar('sample_type', $this->session->get('sample_type'));
        }

        if (!$this->session->has('organism')) {
            $this->flashSession->warning("Please select Organism");
            return $this->response->redirect("order/newOrder");
        } else {
            $this->view->setVar('organism', $this->session->get('organism'));
        }

        $seqlib_undecided = $this->session->get('seqlib_undecided');
        $this->view->setVar('seqlib_undecided', $seqlib_undecided);
        if ($seqlib_undecided->name === "false") {
            if (!$this->session->has('step')) {
                $this->flashSession->warning("Please select Experiment Step");
                return $this->response->redirect("order/newOrder");
            } else {
                $this->view->setVar('step', $this->session->get('step'));
            }

            if (!$this->session->has('protocol')) {
                $this->flashSession->warning("Please select Experiment Protocol");
                return $this->response->redirect("order/newOrder");
            } else {
                $this->view->setVar('protocol', $this->session->get('protocol'));
            }
        }


        $seqrun_undecided = $this->session->get('seqrun_undecided');
        $this->view->setVar('seqrun_undecided', $seqrun_undecided);
        if ($seqrun_undecided->name === "false") {
            if (!$this->session->has('instrument_type')) {
                $this->flashSession->warning("Please select Instrument Type");
                return $this->response->redirect("order/newOrder");
            } else {
                $this->view->setVar('instrument_type', $this->session->get('instrument_type'));
            }

            if (!$this->session->has('seq_runmode_type')) {
                $this->flashSession->warning("Please select Seq Run Mode");
                return $this->response->redirect("order/newOrder");
            } else {
                $this->view->setVar('seq_runmode_type', $this->session->get('seq_runmode_type'));
            }

            if (!$this->session->has('seq_runread_type')) {
                $this->flashSession->warning("Please select Seq Read Type");
                return $this->response->redirect("order/newOrder");
            } else {
                $this->view->setVar('seq_runread_type', $this->session->get('seq_runread_type'));
            }

            if (!$this->session->has('seq_runcycle_type')) {
                $this->flashSession->warning("Please select Seq Read Type");
                return $this->response->redirect("order/newOrder");
            } else {
                $this->view->setVar('seq_runcycle_type', $this->session->get('seq_runcycle_type'));
            }
        }
    }
}
