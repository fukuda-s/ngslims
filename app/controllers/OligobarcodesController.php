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
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                $protocol_id = $this->request->getPost('protocol_id');
                //After editing protocol on handsontable, protocol_id is sent by '(protocol_)name' not '(protocol_)id'.
                //Then protocol_name changed to protocol_id
                if (!is_numeric($protocol_id)) {
                    $protocol = Protocols::findFirst(array(
                        "name = :name:",
                        'bind' => array(
                            'name' => $protocol_id
                        )
                    ));
                    $protocol_id = $protocol->id;
                }

                if ($protocol_id == 0) { //Case that requested from editSeqlibs first (before edit protocol on handsontable) Action
                    $phql = "
                        SELECT
                            o.id, o.name, o.barcode_seq, os.is_oligobarcodeB
                        FROM
                            Oligobarcodes o
                                LEFT JOIN
                            OligobarcodeSchemes os ON os.id = o.oligobarcode_scheme_id
                                LEFT JOIN
                            OligobarcodeSchemeAllows osa ON osa.oligobarcode_scheme_id = os.id
                        WHERE
                            os.active = 'Y'
                    ";
                    $oligobarcodes = $this->modelsManager->executeQuery($phql);
                } else {
                    $phql = "
                        SELECT
                            o.id, o.name, o.barcode_seq, os.is_oligobarcodeB
                        FROM
                            Oligobarcodes o
                                LEFT JOIN
                            OligobarcodeSchemes os ON os.id = o.oligobarcode_scheme_id
                                LEFT JOIN
                            OligobarcodeSchemeAllows osa ON osa.oligobarcode_scheme_id = os.id
                        WHERE osa.protocol_id = :protocol_id:
                        AND os.active = 'Y'
                    ";
                    $oligobarcodes = $this->modelsManager->executeQuery($phql, array(
                        'protocol_id' => $protocol_id
                    ));
                }
                echo json_encode($oligobarcodes->toArray());
            }
        }
    }
}
