<?php
use Phalcon\Logger\Formatter\Json;

class SeqlibsController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of SeqlibsController";
    }

    public function loadjsonAction($step_id, $project_id)
    {
        $this->view->disable();
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                $step_id = $this->filter->sanitize($step_id, array(
                    "int"
                ));
                $project_id = $this->filter->sanitize($project_id, array(
                    "int"
                ));
                $query = $request->getPost('query', 'striptags');
                $query = $this->filter->sanitize($query, array(
                    "striptags"
                ));

                $seqlibs_array = [];
                if (!empty($query)) {
                    $seqlibs = Seqlibs::find(array(
                        "name LIKE :query:",
                        'bind' => array(
                            'query' => '%' . $query . '%'
                        )
                    ));
                    $i = 0;
                    foreach ($seqlibs as $seqlib) {
                        $seqlibs_array[$i]['id'] = $seqlib->id;
                        $seqlibs_array[$i]['name'] = $seqlib->name;
                        $seqlibs_array[$i]['sample_name'] = $seqlib->Samples->name;
                        $seqlibs_array[$i]['protocol_id'] = $seqlib->protocol_id;
                        $seqlibs_array[$i]['oligobarcodeA_id'] = $seqlib->oligobarcodeA_id;
                        $seqlibs_array[$i]['oligobarcodeB_id'] = $seqlib->oligobarcodeB_id;
                        $seqlibs_array[$i]['bioanalyser_chip_code'] = $seqlib->bioanalyser_chip_code;
                        $seqlibs_array[$i]['concentration'] = $seqlib->concentration;
                        $seqlibs_array[$i]['stock_seqlib_volume'] = $seqlib->stock_seqlib_volume;
                        $seqlibs_array[$i]['fragment_size'] = $seqlib->fragment_size;
                        $seqlibs_array[$i]['started_at'] = $seqlib->started_at;
                        $seqlibs_array[$i]['finished_at'] = $seqlib->finished_at;
                        if ($seqlib->StepEntries) {
                            $seqlibs_array[$i]['status'] = $seqlib->StepEntries->status;
                        } else {
                            $seqlibs_array[$i]['status'] = '';
                        }

                        $i++;
                    }
                } elseif ($step_id == 0) { //Case that requested from editSamples Action
                    $phql = "
                        SELECT sl.*,
                               se.*
                        FROM Seqlibs sl
                        LEFT JOIN StepEntries se ON se.seqlib_id = sl.id
                        WHERE sl.project_id = :project_id:
                    ";
                    $seqlibs = $this->modelsManager->executeQuery($phql, array(
                        'project_id' => $project_id
                    ));
                    $seqlibs_array = $seqlibs->toArray();
                } else {
                    $phql = "
                        SELECT sl.*,
                               se.*
                        FROM Seqlibs sl
                        JOIN Protocols p ON p.id = sl.protocol_id
                        JOIN Steps stp ON stp.id = p.step_id
                        LEFT JOIN StepEntries se ON se.seqlib_id = sl.id
                        WHERE sl.project_id = :project_id:
                        AND stp.id = :step_id:
                    ";
                    $seqlibs = $this->modelsManager->executeQuery($phql, array(
                        'project_id' => $project_id,
                        'step_id' => $step_id
                    ));
                    $seqlibs_array = $seqlibs->toArray();
                }
                //echo json_encode($this->handsontableHelper->getValuesArr($samples->toArray()));
                echo json_encode($seqlibs_array);
            }
        }
    }
}
