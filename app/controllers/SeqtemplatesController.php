<?php
use Phalcon\Logger\Formatter\Json;

class SeqtemplatesController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of SeqtemplatesController";
    }

    public function loadjsonAction()
    {
        $this->view->disable();
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                $query = $request->getPost('query', 'striptags');

                if (!empty($query)) {
                    if (is_array($query)) {
                        $seqtemplates = $this->modelsManager->createBuilder()
                            ->from('Seqtemplates')
                            ->inWhere('name', $query)
                            ->getQuery()
                            ->execute();
                    } else if (!empty($query)) {
                        $seqtemplates = Seqtemplates::find(array(
                            "name LIKE :query:",
                            'bind' => array(
                                'query' => '%' . $query . '%'
                            )
                        ));
                    }
                }

                //Set sample_property_entries for each sample.
                echo json_encode($seqtemplates->toArray());
            }
        }
    }
}
