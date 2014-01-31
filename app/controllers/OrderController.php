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
        $this->view->setVar('labs', Labs::find("active = 'Y'"));
        $this->view->setVar('sampletypes', SampleTypes::find(array(
            "active = 'Y'",
            "order" => "sort_order IS NULL ASC, sort_order ASC"
        )));
        $this->view->setVar('organisms', Organisms::find(array(
            "active = 'Y'",
            "order" => "sort_order IS NULL ASC, sort_order ASC"
        )));

        //$this->tag->setDefault('lab_id', 1);
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


                //Set default selected pi_user_id with session's user.
                $this->tag->setDefault('pi_user_id', $auth['id']);

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
                    echo '<option value="@"Sample Type is necessary...</option>';
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
                if ($step_id === undefined || $step_id === '@') {
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
                if ($step_id === undefined || $step_id === '@') {
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
                            "seq_runmode_type_id",
                            value => $seq_runmode_type->id
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
                            "seq_runread_type_id",
                            value => $seq_runread_type->id
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
                            "seq_runcycle_type_id",
                            value => $seq_runcycle_type->id
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

                if (empty($column) || empty($id) || empty($name)) {
                    $this->flash->error("Model: " . $column . ", id: " . $id . ", name: " . $name);
                    return;
                } else {
                    $this->session->set($column, array($id => $name));
                    $this->flash->error(var_dump($this->session->get($column)));
                }

            }
        }
    }
}
