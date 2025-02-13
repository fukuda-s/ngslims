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

class SeqlibsController extends ControllerBase
{

    public function initialize()
    {
        $this->view->disable();
        parent::initialize();
    }

    public function indexAction()
    {
        echo "This is index of SeqlibsController";
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
                $project_id = $request->getPost('project_id', 'int');
                $status = $request->getPost('status', 'striptags');
                $query = $request->getPost('query', 'striptags');

                $seqlibs_tmp = $this->modelsManager->createBuilder()
                    ->columns(array('sl.*', 'ste.*'))
                    ->addFrom('Seqlibs', 'sl')
                    ->join('StepEntries', 'ste.seqlib_id = sl.id', 'ste')
                    ->where('sl.id IS NOT NULL'); /* dummy to concatenate andWhere as follows */

                if (!empty($type) and $type == 'PICK') { /* PICK is not status_id */
                    $seqlibs_tmp = $seqlibs_tmp->leftJoin('CherryPickingSchemes', 'cps.seqlib_id = sl.id', 'cps');
                    $seqlibs_tmp = $seqlibs_tmp->leftJoin('CherryPickings', 'cp.id = cps.cherry_picking_id', 'cp');
                    $seqlibs_tmp = $seqlibs_tmp->andWhere('cp.id = :cherry_picking_id:', array('cherry_picking_id' => $project_id)); //$project_id has cherry_picking_id
                } elseif ($project_id) {
                    $seqlibs_tmp = $seqlibs_tmp->andWhere('sl.project_id = :project_id:', array('project_id' => $project_id));
                }
                
                if ($step_id) {
                    $seqlibs_tmp = $seqlibs_tmp->andWhere('ste.step_id = :step_id:', array('step_id' => $step_id));
                }
                
                if (!empty($status)) {
                    if ($status === 'NULL') {
                        $seqlibs_tmp = $seqlibs_tmp->andWhere('ste.status IS NULL');
                    } elseif ($project_id) {
                        $seqlibs_tmp = $seqlibs_tmp->andWhere('sl.project_id = :project_id:', array('project_id' => $project_id));
                    } else {
                        $seqlibs_tmp = $seqlibs_tmp->andWhere('ste.status = :status:', array('status' => $status));
                    }
                }
                
                if (!empty($query)) {
                    $seqlibs_tmp = $seqlibs_tmp->andWhere('sl.name LIKE :query:', array('query' => '%' . $query . '%'));
                }

                $seqlibs = $seqlibs_tmp->getQuery()
                    ->execute();

                /*
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
                        if ($seqlib->StepEntries_BelongsTo) {
                            $seqlibs_array[$i]['status'] = $seqlib->StepEntries_BelongsTo->status;
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
                */
                echo json_encode($seqlibs->toArray());
            }
        }
    }
}
