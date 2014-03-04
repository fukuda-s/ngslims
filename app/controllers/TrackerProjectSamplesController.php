<?php
use Phalcon\Tag, Phalcon\Acl;

class TrackerProjectSamplesController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateAfter('main');
        Tag::setTitle('Manage your product samples');
        parent::initialize();
    }

    public function indexAction()
    {
        echo "Index of TrackerProjectSamples";
    }

    public function showTableSamplesAction($project_id)
    {
        $project_id = $this->filter->sanitize($project_id, array(
            "int"
        ));
        // $this->flash->success($project_id);

        $phql = 'SELECT
					s.id AS sample_id,
					s.name AS sample_name,
					st.name AS sample_type,
					stp.id AS seqtemplate_id,
					stp.name AS seqtemplate_name,
					slib.id AS seqlib_id,
					slib.name AS seqlib_name,
					oa.name AS oligobarcodeA_name,
					oa.barcode_seq AS oligobarcodeA_seq,
					ob.name AS oligobarcodeB_name,
					ob.barcode_seq AS oligobarcodeB_seq,
					fc.name AS flowcell_name,
					slane.number AS seqlane_num,
					s.qual_date AS qual_date,
					slib.finished_at AS seqlib_date,
					slane.last_cycle_date AS last_cycle_date
				 FROM
					Samples s
						LEFT JOIN
					SampleTypes st ON st.id = s.sample_type_id
						LEFT JOIN
					SeqLibs slib ON slib.sample_id = s.id
						LEFT JOIN
					Oligobarcodes oa ON oa.id = slib.oligobarcodeA_id
						LEFT JOIN
					Oligobarcodes ob ON ob.id = slib.oligobarcodeB_id
						LEFT JOIN
					SeqtemplateAssocs sta ON sta.seqlib_id = slib.id
						LEFT JOIN
					Seqtemplates stp ON stp.id = sta.seqtemplate_id
						LEFT JOIN
					Seqlanes slane ON slane.seqtemplate_id = stp.id
						LEFT JOIN
					Flowcells fc ON fc.id = slane.flowcell_id
				WHERE
					s.project_id = :project_id:
				';
        $datas = $this->modelsManager->executeQuery($phql, array(
            'project_id' => $project_id
        ));
        $this->view->setVar('datas', $datas);
        // $this->flash->success(var_dump($data));

        /*
         * Get Project table
         */
        $this->view->setVar('project', Projects::findFirstById($project_id));

        // $this->flash->success($project->users->name . " " . $project->name);
        // $this->flash->success(var_dump($samples[0]->seqlibs[0]->seqtemplates[0]));
    }

    public function showPanelSamplesAction($project_id)
    {
        $project_id = $this->filter->sanitize($project_id, array(
            "int"
        ));
    }

    public function showPanelSeqlibsAction($project_id)
    {
        $project_id = $this->filter->sanitize($project_id, array(
            "int"
        ));
    }

    public function showPanelSeqlanesAction($project_id)
    {
        $project_id = $this->filter->sanitize($project_id, array(
            "int"
        ));
    }

    public function editSamplesAction($type, $step_id, $project_id)
    {
        $project_id = $this->filter->sanitize($project_id, array(
            "int"
        ));
        /*
         * Get Project table
         */
        $this->view->setVar('project', Projects::findFirstById($project_id));
        $this->view->setVar('type', $type);
        if ($type == 'SHOW' && $step_id == 0) {
            $this->view->setVar('step', (object)array('id' => 0));
        } else {
            $this->view->setVar('step', Steps::findFirstById($step_id));
        }
    }

    public function saveSamplesAction()
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                if ($request->hasPost('data') && $request->hasPost('changes')) {
                    $changes = $request->getPost('changes');
                    $data = $request->getPost('data');

                    /*
                     * $changes has array [["row number from 0", "row name", "before value", "changed value"]] ex.)[["3","qual_od260230","","1"]]
                     */
                    $i = 0;
                    foreach ($changes as $key => $value) {
                        $rowNumToChange = $value[0];
                        $colNameToChange = $value[1];
                        $valueChangeFrom = $value[2];
                        $valueChangeTo = (empty($value[3])) ? NULL : $value[3];
                        // Get sample_id from $data
                        $sample_id = $data[$rowNumToChange]["id"];
                        $sample = Samples::findFirstById($sample_id);


                        if ($colNameToChange == 'to_prep_protocol_name') {
                            continue; //Skip for to_prep_protocol_name
                        } elseif ($colNameToChange === 'to_prep' && $valueChangeTo === 'true') {
                            //Set up protocol values
                            $protocol_name = $data[$rowNumToChange]["to_prep_protocol_name"];
                            $protocol = Protocols::findFirst(array(
                                "name = :name:",
                                'bind' => array(
                                    'name' => $protocol_name
                                )
                            ));
                            if (!$protocol) {
                                $this->flashSession->error("Please select Protocol if you need to create new seqlibs.");
                                return;
                            }

                            //Set PREP step to StepEntries
                            $seqlib_step_entries[0] = new StepEntries();
                            $seqlib_step_entries[0]->step_id = $protocol->step_id;
                            $seqlib_step_entries[0]->step_phase_code = $protocol->getSteps()->step_phase_code; //Should be 'PREP'
                            $seqlib_step_entries[0]->protocol_id = $protocol->id;

                            //Set data to Seqlibs
                            $seqlib = new Seqlibs();
                            $seqlib->name = $sample->name . '_' . date("Ymd");
                            $seqlib->sample_id = $sample_id;
                            $seqlib->project_id = $sample->project_id;
                            $seqlib->protocol_id = $protocol->id;

                            // Tied (seqlib) StepEntries to Seqlibs
                            $seqlib->StepEntries = $seqlib_step_entries[0];

                            if (!$seqlib->save()) {
                                foreach ($seqlib->getMessages() as $message) {
                                    $this->flashSession->error((string)$message);
                                }
                                return;
                            } else {
                                $this->flashSession->success($seqlib->name . " is saved.");
                            }


                        } else {
                            $sample->$colNameToChange = $valueChangeTo;
                            if (!$sample->save()) {
                                foreach ($sample->getMessages() as $message) {
                                    $this->flashSession->error((string)$message);
                                }
                                return;
                            }
                        }
                    }

                    // Something return is necessary for frontend jQuery Ajax to find success or fail.
                    echo json_encode($changes);
                }
            }
        }
    }

    public function editSeqlibsAction($type, $step_id, $project_id)
    {
        $step_id = $this->filter->sanitize($step_id, array(
            "int"
        ));
        $project_id = $this->filter->sanitize($project_id, array(
            "int"
        ));
        $this->view->setVar('project', Projects::findFirstById($project_id));
        $this->view->setVar('type', $type);
        if ($type == 'SHOW') {
            $this->view->setVar('step', (object)array('id' => 0));
        } else {
            $this->view->setVar('step', Steps::findFirstById($step_id));
        }
    }

    public function saveSeqlibsAction()
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                if ($request->hasPost('data') && $request->hasPost('changes')) {
                    $changes = $request->getPost('changes');
                    $data = $request->getPost('data');

                    foreach ($changes as $key => $value) {
                        $rowNumToChange = $value[0];
                        $colStrToChange = preg_split('/\./', $value[1]);
                        $tblNameToChange = $colStrToChange[0];
                        $colNameToChange = $colStrToChange[1];

                        $valueChangeTo = (empty($value[3])) ? NULL : $value[3];
                        $seqlib_id = $data[$rowNumToChange]['sl']['id']; //'sl' is alias of Seqlibs on SeqlibsController->loadjson()

                        $seqlib = Seqlibs::findFirstById($seqlib_id);

                        //Set up StepEntries for this seqlib with PREP step
                        $seqlib_step_entries = StepEntries::findFirst(array(
                            "seqlib_id = :seqlib_id:",
                            'bind' => array(
                                'seqlib_id' => $seqlib_id
                            )
                        ));
                        $seqlib_protocol = $seqlib->getProtocols();
                        if(!$seqlib_step_entries){
                            $seqlib_step_entries = new StepEntries();
                            $seqlib_step_entries->seqlib_id = $seqlib->id;
                            $seqlib_step_entries->step_id = $seqlib_protocol->step_id;
                            $seqlib_step_entries->step_phase_code = $seqlib_protocol->getSteps()->step_phase_code; //Should be 'PREP'
                            $seqlib_step_entries->protocol_id = $seqlib->protocol_id;
                        }

                        if ($colNameToChange === 'protocol_id') {
                            $seqlib_protocol = Protocols::findFirst(array(
                                "name = :name:",
                                'bind' => array(
                                    'name' => $valueChangeTo
                                )
                            ));
                            $seqlib->protocol_id = $seqlib_protocol->id;
                            $seqlib_step_entries->step_id = $seqlib_protocol->step_id;
                            $seqlib_step_entries->step_phase_code = $seqlib_protocol->step_phase_code; //Should be 'PREP'
                            $seqlib_step_entries->protocol_id = $seqlib_protocol->id;

                        } elseif (preg_match("/^oligobarcode[AB]_id$/", $colNameToChange, $columnName)) {
                            $oligobarcodeStr = preg_split("/ : /", $valueChangeTo);
                            if (count($oligobarcodeStr) > 1) { //Case if oligobarcode_id selected null (then $valueToChange should be blank).
                                $oligobarcode_name = $oligobarcodeStr[0];
                                $oligobarcode_seq = $oligobarcodeStr[1];
                                $oligobarcode = Oligobarcodes::findFirst(array(
                                    "name = :name: AND barcode_seq = :barcode_seq:",
                                    'bind' => array(
                                        'name' => $oligobarcode_name,
                                        'barcode_seq' => $oligobarcode_seq
                                    )
                                ));

                                $seqlib->$columnName[0] = $oligobarcode->id;
                            } else {
                                $seqlib->$columnName[0] = null;
                            }
                        } elseif( $tblNameToChange === 'se') { //'se' is alias of StepEntries on SeqlibsController->loadjson()
                            $seqlib_step_entries->$colNameToChange = $valueChangeTo;
                        } else {
                            $seqlib->$colNameToChange = $valueChangeTo;
                        }

                        // @TODO Is it possible to tie $seqlib_step_entries to $seqlib and save (update) at onetime?
                        if (!$seqlib_step_entries->save()) {
                            foreach ($seqlib_step_entries->getMessages() as $message) {
                                $this->flashSession->error((string)$message);
                                echo "Error to save seqlib_step_entries: $message";
                            }
                            return;
                        }

                        // @TODO Validation should be added. started_date <= finished_date
                        if (!$seqlib->save()) {
                            foreach ($seqlib->getMessages() as $message) {
                                $this->flashSession->error((string)$message);
                                echo "Error to save seqlib: $message";
                            }
                            return;
                        }
                    }
                    // Something return is necessary for frontend jQuery Ajax to find success or fail.
                    echo json_encode($changes);
                }
            }
        }
    }

    public function editSeqlanesAction($type, $step_id, $project_id)
    {
        $project_id = $this->filter->sanitize($project_id, array(
            "int"
        ));
        $this->view->setVar('project', Projects::findFirstById($project_id));
        $this->view->setVar('type', $type);
        if ($type == 'SHOW' && $step_id == 0) {
            $this->view->setVar('step', (object)array('id' => 0));
        } else {
            $this->view->setVar('step', Steps::findFirstById($step_id));
        }
    }

    public function saveSeqlanesAction()
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                if ($request->hasPost('data') && $request->hasPost('changes')) {
                    $changes = $request->getPost('changes');
                    $data = $request->getPost('data');

                    foreach ($changes as $key => $value) {
                        $rowNumToChange = $value[0];
                        $colNameToChange = $value[1];
                        $valueToChange = (empty($value[3])) ? NULL : $value[3];
                        $sample_id = $data[$rowNumToChange]["id"];

                        $samples = Samples::findFirst("id = $sample_id");
                        $samples->$colNameToChange = $valueToChange;
                        if (!$samples->save()) {
                            foreach ($samples->getMessages() as $message) {
                                $this->flash->error((string)$message);
                            }
                            return;
                        }
                    }
                    // Something return is necessary for frontend jQuery Ajax to find success or fail.
                    echo json_encode($changes);
                }
            }
        }
    }

    public function showTubeSeqLibsAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_MAIN_LAYOUT);
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_AFTER_TEMPLATE);
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                $step_id = $this->request->getPost("step_id", "int");
                $project_id = $this->request->getPost("project_id", "int");

                $phql = "
                    SELECT
                        sl.*,
                        se.*
                    FROM
                        Seqlibs sl
                            LEFT JOIN
                        StepEntries se ON se.seqlib_id = sl.id
                            LEFT JOIN
	                    Protocols p ON p.id = se.protocol_id
		                    LEFT JOIN
	                    Steps st ON st.step_phase_code = p.next_step_phase_code AND st.id = :step_id:
                    WHERE
                        sl.project_id = :project_id:
                ";
                $seqlibs = $this->modelsManager->executeQuery($phql, array(
                    'project_id' => $project_id,
                    'step_id' => $step_id
                ));

                $this->view->setVar('seqlibs', $seqlibs);
            }
        }
    }
}