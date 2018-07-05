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

class SamplesController extends ControllerBase
{

    public function initialize()
    {
        $this->view->disable();
        parent::initialize();
    }

    public function indexAction()
    {
        echo "This is index of SamplesController";
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
                $type = $request->getPost('type', 'striptags');
                $step_id = $request->getPost('step_id', 'int');
                $project_id = $request->getPost('project_id', 'int');
                $status = $request->getPost('status', 'striptags');
                $nucleotide_type = $request->getPost('nucleotide_type', 'striptags');
                $query = $request->getPost('query', 'striptags');

                $samples_tmp = $this->modelsManager->createBuilder()
                    ->columns(array('s.*', 'ste.*'))
                    ->addFrom('Samples', 's')
                    ->leftJoin('SampleTypes', 'st.id = s.sample_type_id', 'st')
                    //->join('Steps', 'stp.nucleotide_type = st.nucleotide_type', 'stp')
                    ->leftJoin('StepEntries', 'ste.sample_id = s.id', 'ste')
                    ->where('s.id IS NOT NULL'); /* dummy to concatenate andWhere as follows. */

                if (!empty($type) and $type == 'PICK') { /* PICK is not status_id */
                    $samples_tmp = $samples_tmp->leftJoin('CherryPickingSchemes', 'cps.sample_id = s.id', 'cps');
                    $samples_tmp = $samples_tmp->leftJoin('CherryPickings', 'cp.id = cps.cherry_picking_id', 'cp');
                    $samples_tmp = $samples_tmp->andWhere('cp.id = :cherry_picking_id:', array('cherry_picking_id' => $project_id)); //$project_id has cherry_picking_id
                } elseif ($project_id) {
                    $samples_tmp = $samples_tmp->andWhere('s.project_id = :project_id:', array('project_id' => $project_id));
                }

                if ($step_id) {
                    $samples_tmp = $samples_tmp->andWhere('ste.step_id = :step_id:', array('step_id' => $step_id));
                }

                if (!empty($status)) {
                    if ($status === 'NULL') {
                        $samples_tmp = $samples_tmp->andWhere('ste.status IS NULL');
                    } else {
                        $samples_tmp = $samples_tmp->andWhere('ste.status = :status:', array('status' => $status));
                    }
                }

                if (!empty($nucleotide_type)) {
                    $samples_tmp = $samples_tmp->andWhere('st.nucleotide_type = :nucleotide_type:', array('nucleotide_type' => $nucleotide_type));
                }

                if (!empty($query)) {
                    $samples_tmp = $samples_tmp->andWhere('s.name LIKE :query:', array('query' => '%' . $query . '%'));
                }

                $samples = $samples_tmp->getQuery()
                    ->execute();


                //Set sample_property_entries for each sample.
                $samples_array = array();
                foreach ($samples as $sample) {
                    $sample_array = $sample->toArray();
                    $sample_property_entries = $sample->s->getSamplePropertyEntries();
                    //echo json_encode($sample_property_entries->toArray());
                    if ($sample_property_entries) {
                        $sample_property_entries_array = array();
                        foreach ($sample_property_entries as $sample_property_entry) {
                            //echo json_encode($sample_property_entry->toArray());
                            $sample_property_type = $sample_property_entry->SamplePropertyTypes;
                            $sample_property_entries_array[$sample_property_type->id] = $sample_property_entry->value;
                        }
                        $sample_array['sample_property_types'] = $sample_property_entries_array;
                    }
                    array_push($samples_array, $sample_array);
                }
                echo json_encode($samples_array);
            }
        }
    }
}
