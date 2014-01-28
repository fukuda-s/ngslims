<?php
use Phalcon\Logger\Formatter\Json;

class SeqlibsController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of SeqlibsController";
    }

    public function loadjsonAction($project_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                $project_id = $this->filter->sanitize($project_id, array(
                    "int"
                ));

                $seqlibs = Seqlibs::find(array(
                    "project_id = :project_id:",
                    'bind' => array(
                        'project_id' => $project_id
                    )
                ));
                //echo json_encode($this->handsontableHelper->getValuesArr($samples->toArray()));
                echo json_encode($seqlibs->toArray());
            }
        }
    }
}
