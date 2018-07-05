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

class ProjectsController extends ControllerBase
{

    public function initialize()
    {
        $this->view->disable();
        parent::initialize();
    }

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

                $projects = Projects::find();
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
