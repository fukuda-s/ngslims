<?php

class ProtocolsController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of ProtocolsController";
    }

    public function loadjsonAction($step_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isGet() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";

                $protocols = Protocols::find(array(
                    "step_id = :step_id: AND active = 'Y'",
                    'bind' => array(
                        'step_id' => $step_id
                    )
                ));
                echo json_encode($protocols->toArray());
            }
        }
    }
}
