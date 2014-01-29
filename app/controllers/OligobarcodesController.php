<?php
use Phalcon\Logger\Formatter\Json;

class OligobarcodesController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of OligobarcodesController";
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

                $oligobarcodes = Oligobarcodes::find(array(
                    "active = 'Y'",
                    "order" => "sort_order IS NULL ASC, sort_order ASC"
                ));
                echo json_encode($oligobarcodes->toArray());
            }
        }
    }
}
