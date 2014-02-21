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
                    $seqlibs = Seqlibs::find(array(
                        "project_id = :project_id:",
                        'bind' => array(
                            'project_id' => $project_id
                        )
                    ));
                } else {
                    $seqlibs = $this->modelsManager->createBuilder()
                        ->from('Seqlibs')
                        ->join('Protocols', 'p.id = Seqlibs.protocol_id', 'p')
                        ->join('Steps', 'stp.id = p.step_id', 'stp')
                        ->where('Seqlibs.project_id = :project_id:', array('project_id' => $project_id))
                        ->andWhere('stp.id = :step_id:', array('step_id' => $step_id))
                        ->getQuery()
                        ->execute();
                }
                //echo json_encode($this->handsontableHelper->getValuesArr($samples->toArray()));
                echo json_encode($seqlibs->toArray());
            }
        }
    }
}
