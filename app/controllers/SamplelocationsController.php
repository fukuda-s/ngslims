<?php

class SampleLocationsController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of SampleLocationsController";
    }

    public function loadjsonAction()
    {
        $this->view->disable();
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isGet() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";

                $samplelocations = SampleLocations::find(array(
                    "active = 'Y'",
                    "order" => "name ASC"
                ));
                echo json_encode($samplelocations->toArray());
            }
        }
    }
}
