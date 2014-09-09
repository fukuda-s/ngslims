<?php
use Phalcon\Logger\Formatter\Json;

class OligobarcodesController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of OligobarcodesController";
    }

    public function loadjsonAction($step_id = 0)
    {
        $this->view->disable();
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                $protocol_id = $request->getPost('protocol_id', array('int', 'string'));

                if ($step_id !== 0) { //Case that requested from editSeqlibs first (before edit protocol on handsontable) Action
                    $oligobarcodes = $this->modelsManager->createBuilder()
                        ->columns(array('o.id', 'o.name', 'o.barcode_seq', 'os.is_oligobarcodeB'))
                        ->addFrom('Oligobarcodes', 'o')
                        ->join('OligobarcodeSchemes', 'os.id = o.oligobarcode_scheme_id', 'os')
                        ->join('OligobarcodeSchemeAllows', 'osa.oligobarcode_scheme_id = os.id', 'osa')
                        ->join('Protocols', 'p.id = osa.protocol_id', 'p')
                        ->where('o.active = "Y"')
                        ->andWhere('os.active = "Y"')
                        ->andWhere('p.step_id = :step_id:', array("step_id" => $step_id))
                        ->groupBy('o.id')
                        ->orderBy('os.id ASC, o.sort_order ASC')
                        ->getQuery()
                        ->execute();
                    echo json_encode($oligobarcodes->toArray());
                    return;
                } else if (is_numeric($protocol_id)) {
                    $oligobarcodes = $this->modelsManager->createBuilder()
                    ->columns(array('o.id', 'o.name', 'o.barcode_seq', 'os.is_oligobarcodeB'))
                        ->addFrom('Oligobarcodes', 'o')
                        ->join('OligobarcodeSchemes', 'os.id = o.oligobarcode_scheme_id', 'os')
                        ->join('OligobarcodeSchemeAllows', 'osa.oligobarcode_scheme_id = os.id', 'osa')
                        ->where('o.active = "Y"')
                        ->andWhere('os.active = "Y"')
                        ->andWhere('osa.protocol_id = :protocol_id:', array('protocol_id' => $protocol_id))
                        ->groupBy('o.id')
                        ->orderBy('os.id ASC, o.sort_order ASC')
                        ->getQuery()
                        ->execute();
                    echo json_encode($oligobarcodes->toArray());
                    return;
                }
            }
        }
    }
}
