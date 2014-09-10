<?php

class ProjectsController extends ControllerBase
{

    public function indexAction()
    {
        echo "This is index of ProjectsController";
    }

    public function loadjsonAction()
    {
        $this->view->disable();
        $request = $this->request;
        $projects_array = [];
        // Check whether the request was made with method POST
        if ($request->isGet() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";

                $projects = Projects::find(array());
                //echo json_encode($projects->toArray());
                $i = 0;
                foreach ($projects as $project) {
                    $projects_array[$i]['id'] = $project->id;
                    $projects_array[$i]['name'] = $project->name;
                    $projects_array[$i]['user_id'] = $project->user_id;
                    $projects_array[$i]['user_name'] = $project->Users->getFullname();
                    if ($project->PIs) {
                        $projects_array[$i]['pi_user_id'] = $project->pi_user_id;
                        $projects_array[$i]['pi_name'] = $project->PIs->getFullname();
                    } else {
                        $projects_array[$i]['pi_user_id'] = '';
                        $projects_array[$i]['pi_name'] = 'Undefined';
                    }
                    $projects_array[$i]['project_type_name'] = $project->ProjectTypes->name;
                    $i++;
                }

                echo json_encode($projects_array);
            }
        }
    }
}
