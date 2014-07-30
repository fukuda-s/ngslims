<?php
use Phalcon\Logger\Formatter\Json;

class SamplesController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of SamplesController";
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

                if ($step_id == 0) { //Case that requested from editSamples Action
                    $samples = Samples::find(array(
                        "project_id = :project_id:",
                        'bind' => array(
                            'project_id' => $project_id
                        )
                    ));
                } else {
                    $samples = $this->modelsManager->createBuilder()
                        ->from('Samples')
                        ->join('SampleTypes', 'st.id = Samples.sample_type_id', 'st')
                        ->join('Steps', 'stp.nucleotide_type = st.nucleotide_type', 'stp')
                        ->where('Samples.project_id = :project_id:', array('project_id' => $project_id))
                        ->andWhere('stp.id = :step_id:', array('step_id' => $step_id))
                        ->getQuery()
                        ->execute();
                }

                //Set sample_property_entries for each sample.
                $samples_array = array();
                foreach ($samples as $sample) {
                    $sample_array = $sample->toArray();
                    $sample_property_entries = $sample->SamplePropertyEntries;
                    //echo json_encode($sample_property_entries->toArray());
                    if($sample_property_entries){
                        $sample_property_entries_array = array();
                        foreach($sample_property_entries as $sample_property_entry){
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
