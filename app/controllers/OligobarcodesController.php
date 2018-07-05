<?php
/**
 * (The MIT License)
 *
 * Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * 'Software'), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

use Phalcon\Logger\Formatter\Json;

class OligobarcodesController extends ControllerBase
{

    public function initialize()
    {
        $this->view->disable();
        parent::initialize();
    }

    public function indexAction()
    {
        echo "This is index of OligobarcodesController";
    }

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
                $protocol_id = $request->getPost('protocol_id', 'striptags');

                if ($type == 'PREP' and $step_id != 0) { //Case that requested from editSeqlibs first (before edit protocol on handsontable) Action
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
                    //echo "[{1:$protocol_id}]";
                    echo json_encode($oligobarcodes->toArray());
                    return;
                } else if ($protocol_id) {
                    if (!is_numeric($protocol_id)) {
                        $protocol = Protocols::findFirst("name = '$protocol_id'");
                        $protocol_id = $protocol->id;
                    }
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
                    //echo "[{2:$protocol_id}]";
                    echo json_encode($oligobarcodes->toArray());
                    return;
                } else {
                    $oligobarcodes = $this->modelsManager->createBuilder()
                        ->columns(array('o.id', 'o.name', 'o.barcode_seq', 'o.sort_order', 'o.oligobarcode_scheme_id', 'o.active', 'os.is_oligobarcodeB'))
                        ->addFrom('Oligobarcodes', 'o')
                        ->leftJoin('OligobarcodeSchemes', 'os.id = o.oligobarcode_scheme_id', 'os')
                        ->groupBy('o.id')
                        ->orderBy('os.id ASC, o.sort_order ASC')
                        ->getQuery()
                        ->execute();
                    //echo "[{3:$protocol_id}]";
                    echo json_encode($oligobarcodes->toArray());
                    return;
                }
            }
        }
    }
}
