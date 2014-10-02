<?php

class SamplesController extends ControllerBase
{

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
                $step_id = $request->getPost('step_id', 'int');
                $project_id = $request->getPost('project_id', 'int');
                $status = $request->getPost('status', 'striptags');
                $nucleotide_type = $request->getPost('nucleotide_type', 'striptags');
                $query = $request->getPost('query', 'striptags');

                $samples_tmp = $this->modelsManager->createBuilder()
                    ->columns(array('s.*', 'ste.*'))
                    ->addFrom('Samples', 's')
                    ->join('SampleTypes', 'st.id = s.sample_type_id', 'st')
                    //->join('Steps', 'stp.nucleotide_type = st.nucleotide_type', 'stp')
                    ->join('StepEntries', 'ste.sample_id = s.id', 'ste')
                    ->where('s.id IS NOT NULL'); /* dummy to concatenate andWhere as follows. */

                if ($step_id) {
                    $samples_tmp = $samples_tmp->andWhere('ste.step_id = :step_id:', array('step_id' => $step_id));
                }
                if ($project_id) {
                    $samples_tmp = $samples_tmp->andWhere('s.project_id = :project_id:', array('project_id' => $project_id));
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
