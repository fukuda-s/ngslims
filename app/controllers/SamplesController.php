<?php
use Phalcon\Logger\Formatter\Json;

class SamplesController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of SamplesController";
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
                    $samples = Samples::find(array(
                        "project_id = :project_id:",
                        'bind' => array(
                            'project_id' => $project_id
                        )
                    ));
                } else {
                    $samples = $this->modelsManager->createBuilder()
                        ->from('Samples')
                        ->join('SampleTypes', 'st.id = Samples.sample_type_id', 'st')
                        ->join('Steps', 'stp.nucleotide_type = st.nucleotide_type', 'stp')
                        ->where('Samples.project_id = :project_id:', array('project_id' => $project_id))
                        ->andWhere('stp.id = :step_id:', array('step_id' => $step_id))
                        ->getQuery()
                        ->execute();
                }
                //echo json_encode($this->handsontableHelper->getValuesArr($samples->toArray()));
                echo json_encode($samples->toArray());
            }
        }
    }
}
