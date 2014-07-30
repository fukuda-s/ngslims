<?php
use Phalcon\Logger\Formatter\Json;

class OrganismsController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of OrganismsController";
    }

    public function loadjsonAction()
    {
        $this->view->disable();
        $request = $this->request;;
        // Check whether the request was made with method POST
        if ($request->isGet() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";

                $organisms = Organisms::find(array(
                    "active = 'Y'",
                    "order" => "sort_order IS NULL ASC, sort_order ASC"
                ));
                echo json_encode($organisms->toArray());
            }
        }
    }
}
