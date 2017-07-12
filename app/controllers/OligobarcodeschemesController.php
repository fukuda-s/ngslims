<?php

class OligobarcodeschemesController extends ControllerBase
{
    public function initialize()
    {
        $this->view->disable();
        parent::initialize();
    }

    public function indexAction()
    {
        echo "This is index of OligobarcodeSchemesController";
    }

    // @TODO $step_id default value should be checked at previous (in javascript) steps.
    public function loadjsonAction()
    {
        $this->view->disable();
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isGet() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";

                $oligobarcodeschemes = OligobarcodeSchemes::find("active = 'Y'");
                echo json_encode($oligobarcodeschemes->toArray());
            }
        }
    }
}