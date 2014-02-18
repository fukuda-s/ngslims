<?php
use Phalcon\Tag;
use Phalcon\Logger\Formatter\Json;

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
        if ( $type == 'SHOW' && $step_id == 0 ){
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
                    foreach ($changes as $key => $value) {
                        $rowNumToChange = $value[0];
                        $colNameToChange = $value[1];
                        $valueToChange = (intval($value[3]) === 0) ? NULL : $value[3];
                        // Get sample_id from $data
                        $sample_id = $data[$rowNumToChange]["id"];

                        $samples = Samples::findFirstById($sample_id);
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

    public function editSeqlibsAction($type, $step_id, $project_id)
    {
        $project_id = $this->filter->sanitize($project_id, array(
            "int"
        ));
        $this->view->setVar('project', Projects::findFirstById($project_id));
        $this->view->setVar('type', $type);
        if ( $type == 'SHOW' && $step_id == 0 ){
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
                        $colNameToChange = $value[1];
                        $valueToChange = $value[3];
                        $seqlib_id = $data[$rowNumToChange]["id"];

                        $seqlibs = Seqlibs::findFirstById($seqlib_id);
                        if ( $colNameToChange === 'protocol_id') {
                            $protocol = Protocols::findFirst(array(
                                "name = :name:",
                                'bind' => array(
                                    'name' => $valueToChange
                                )
                            ));
                            $seqlibs->protocol_id = $protocol->id;
                        } else {
                            $seqlibs->$colNameToChange = $valueToChange;
                        }
                        if (!$seqlibs->save()) {
                            foreach ($seqlibs->getMessages() as $message) {
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

    public function editSeqlanesAction($type, $step_id, $project_id)
    {
        $project_id = $this->filter->sanitize($project_id, array(
            "int"
        ));
        $this->view->setVar('project', Projects::findFirstById($project_id));
        $this->view->setVar('type', $type);
        if ( $type == 'SHOW' && $step_id == 0 ){
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
                        $valueToChange = (intval($value[3]) === 0) ? NULL : $value[3];
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
}