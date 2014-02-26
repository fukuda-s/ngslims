<?php

class ProtocolsController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of ProtocolsController";
    }

    // @TODO $step_id default value should be checked at previous (in javascript) steps.
    public function loadjsonAction($step_id = 0)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isGet() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";

                if ($step_id == 0) { //Case in type=SHOW
                    $protocols = Protocols::find(array(
                        "active = 'Y'",
                    ));

                } else {
                    $protocols = Protocols::find(array(
                        "step_id = :step_id: AND active = 'Y'",
                        'bind' => array(
                            'step_id' => $step_id
                        )
                    ));
                }
                echo json_encode($protocols->toArray());
            }
        }
    }
}
