<?php

class ProtocolsController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of ProtocolsController";
    }

    // @TODO $step_id default value should be checked at previous (in javascript) steps.
    public function loadjsonAction()
    {
        $this->view->disable();
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {

                $type = $request->getPost('type', 'striptags');
                $step_id = $request->getPost('step_id', 'int');

                if (($type == 'SHOW' and $step_id == 0) or $type != 'PREP') {
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
