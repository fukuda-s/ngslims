<?php
use Phalcon\Logger\Formatter\Json;

class SeqlibsController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of SeqlibsController";
    }

    public function loadjsonAction($step_id, $project_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                $step_id = $this->filter->sanitize($step_id, array(
                    "int"
                ));
                $project_id = $this->filter->sanitize($project_id, array(
                    "int"
                ));

                if ($step_id == 0) { //Case that requested from editSamples Action
                    $phql = "
                        SELECT sl.*,
                               se.*
                        FROM SeqLibs sl
                        LEFT JOIN StepEntries se ON se.seqlib_id = sl.id
                        WHERE sl.project_id = :project_id:
                    ";
                    $seqlibs = $this->modelsManager->executeQuery($phql, array(
                        'project_id' => $project_id
                    ));
                } else {
                    $phql = "
                        SELECT sl.*,
                               se.*
                        FROM SeqLibs sl
                        JOIN Protocols p ON p.id = sl.protocol_id
                        JOIN Steps stp ON stp.id = p.step_id
                        LEFT JOIN StepEntries se ON se.seqlib_id = sl.id
                        WHERE sl.project_id = :project_id:
                        AND stp.id = :step_id:
                    ";
                    $seqlibs = $this->modelsManager->executeQuery($phql, array(
                        'project_id' => $project_id,
                        'step_id' => $step_id
                    ));
                }
                //echo json_encode($this->handsontableHelper->getValuesArr($samples->toArray()));
                echo json_encode($seqlibs->toArray());
            }
        }
    }
}
