<?php
use Phalcon\Logger\Formatter\Json;

class SampleTypesController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of SampleTypesController";
    }

    public function loadjsonAction()
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isGet() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";

                $sampletypes = SampleTypes::find(array(
                    "active = 'Y'",
                    "order" => "sort_order IS NULL ASC, sort_order ASC"
                ));
                echo json_encode($sampletypes->toArray());
            }
        }
    }
}
