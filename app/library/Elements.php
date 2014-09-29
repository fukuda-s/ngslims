<?php
use Phalcon\Tag, Phalcon\Mvc\Url;

/**
 * Elements
 *
 * Helps to build UI elements for the application
 */
class Elements extends Phalcon\Mvc\User\Component
{

    private $_headerMenu = array(
        'pull-left' => array(
            /*
            'index' => array (
                    'caption' => 'Home',
                    'action' => 'index'
            ),
            */
            'order' => array(
                'caption' => 'Order',
                'action' => 'index'
            ),
            'tracker' => array(
                'caption' => 'Tracker',
                'action' => 'index'
            ),
            'report' => array(
                'caption' => 'Report',
                'action' => 'index'
            )
        ),
        'pull-right' => array(
            'search' => array(
                'caption' => '',
                'action' => 'result'
            ),
            'session' => array(
                'caption' => 'Log In/Sign Up',
                'action' => 'index'
            ),
            'about' => array(
                'caption' => 'About',
                'action' => 'index'
            )
        )
    );

    private $_userDropdownMenu = array(
        array(
            'caption' => 'Account',
            'controller' => 'session',
            'action' => 'account',
            'class' => ''
        ),
        array(
            'caption' => '',
            'controller' => '',
            'action' => '',
            'class' => 'divider'
        ),
        array(
            'caption' => 'Password',
            'controller' => 'session',
            'action' => 'password',
            'class' => ''
        ),
        array(
            'caption' => '',
            'controller' => '',
            'action' => '',
            'class' => 'divider'
        ),
        array(
            'caption' => 'Log Out',
            'controller' => 'session',
            'action' => 'end',
            'class' => ''
        )
    );

    private $_trackerSideMenu = array(
        'Project PI Overview' => array(
            'controller' => 'summary',
            'action' => 'projectPi',
            'param' => ''
        ),
        'Project Name Overview' => array(
            'controller' => 'summary',
            'action' => 'projectName',
            'param' => ''
        ),
        /*
        'Operation Overview' => array(
            'controller' => 'summary',
            'action' => 'operation',
            'param' => ''
        ),
        */
        'Overall View' => array(
            'controller' => 'summary',
            'action' => 'overall',
            'param' => ''
        ),
        'hr1' => array(),
        'QC Experiment View' => array(
            'controller' => 'tracker',
            'action' => 'experiments',
            'param' => 'QC'
        ),
        'SeqLib Experiment View' => array(
            'controller' => 'tracker',
            'action' => 'experiments',
            'param' => 'PREP'
        ),
        'Indexing and Multiplexing View' => array(
            'controller' => 'tracker',
            'action' => 'experiments',
            'param' => 'MULTIPLEX'
        ),
        'Flowcell Setup View' => array(
            'controller' => 'tracker',
            'action' => 'experiments',
            'param' => 'FLOWCELL'
        ),
        'Sequencing Setup View' => array(
            'controller' => 'tracker',
            'action' => 'sequence',
            'param' => ''
        ),
        'hr2' => array(),
        'Protocol Setting' => array(
            'controller' => 'tracker',
            'action' => 'protocol',
            'param' => ''
        )
    );

    /**
     * Builds header menu with left and right items
     *
     * @return string
     */
    public function getMenu()
    {
        $auth = $this->session->get('auth');
        if ($auth) {
            $this->_headerMenu['pull-right']['session'] = array(
                'caption' => $auth['firstname'] . ' ' . $auth['lastname'],
                'dropdown' => '_userDropdownMenu'
            );
        } else {
            unset($this->_headerMenu['pull-left']['order']);
            unset($this->_headerMenu['pull-left']['tracker']);
            unset($this->_headerMenu['pull-right']['search']);
        }

        $controllerName = $this->view->getControllerName();
        foreach ($this->_headerMenu as $position => $menu) {
            echo '<ul class="nav navbar-nav ', $position, '">';
            foreach ($menu as $controller => $option) {
                if ($controller == 'search') {
                    echo "<li>";
                    echo "<form class='navbar-form' role='search' action='" . $this->url->get($controller . '/' . $option['action']) . "'/>";
                    echo "  <div class='form-group'>";
                    echo "      <input method='post' name='q' type='text' class='form-control' placeholder='Sample Search'/>";
                    echo "  </div>";
                    echo "  <button type='submit' class='btn btn-default' value='action'>Submit</button>";
                    echo "</form>";
                    echo "</li>";
                } elseif (isset($option['dropdown']) && !empty($option['dropdown'])) {
                    $dropdown = $this->$option['dropdown'];
                    //$dropdown = $this->_userDropdownMenu;
                    echo '<li class="dropdown">';
                    echo '<a href="#" class="dropdown-toggle" data-toggle="dropdown">' . $option['caption'] . '<span class="caret"></span></a>';
                    echo '<ul class="dropdown-menu" role="menu">';
                    foreach ($dropdown as $d_menu) {
                        if (isset($d_menu['controller']) && $d_menu['class'] == 'divider') {
                            echo '<li class="divider">';
                        } else {
                            echo '<li class="' . $d_menu['class'] . '">';
                            echo Tag::linkTo($d_menu['controller'] . '/' . $d_menu['action'], $d_menu['caption']);
                        }
                        echo '</li>';
                    }
                    echo '</ul>';

                } else {
                    if ($controllerName == $controller) {
                        echo '<li class="active">';
                    } else {
                        echo '<li>';
                    }
                    echo Tag::linkTo($controller . '/' . $option['action'], $option['caption']);
                    echo '</li>';
                }
            }
            echo '</ul>';
        }
        // echo '</div>';
    }

    public function getTabs()
    {
        $controllerName = $this->view->getControllerName();
        $actionName = $this->view->getActionName();
        echo '<ul class="nav nav-tabs">';
        foreach ($this->_tabs as $caption => $option) {
            if ($option['controller'] == $controllerName && ($option['action'] == $actionName || $option['any'])) {
                echo '<li class="active">';
            } else {
                echo '<li>';
            }
            echo Tag::linkTo($option['controller'] . '/' . $option['action'], $caption), '<li>';
        }
        echo '</ul>';
    }

    /*
     * Bulids side menu for Sample Tracker
     */
    public function getTrackerSideMenu()
    {
        $controllerName = $this->view->getControllerName();
        $actionName = $this->view->getActionName();
        $paramName = '';
        if ($this->view->getParams()) {
            $paramName = $this->view->getParams()[0];
        }
        echo '<ul class="nav nav-pills nav-stacked" data-spy="affix" data-offset-top="50" data-target="#">';
        foreach ($this->_trackerSideMenu as $caption => $option) {
            if (preg_match("/^hr/", $caption)) {
                echo '<hr />';
                continue;
            } elseif ($paramName != '') {
                if ($option['controller'] == $controllerName && ($option['action'] == $actionName) && $option['param'] == $paramName) {
                    echo '<li class="active">';
                } else {
                    echo '<li>';
                }
            } else {
                if ($option['controller'] == $controllerName && ($option['action'] == $actionName)) {
                    echo '<li class="active">';
                } else {
                    echo '<li>';
                }
            }

            echo Tag::linkTo($option['controller'] . '/' . $option['action'] . '/' . $option['param'], $caption), '<li>';
        }
        echo '</ul>';
    }

    /*
     * Build Tracker Project List Items for Project Summary
     */
    public function getTrackerProjectSummaryProjectList($pi_user_id)
    {
        $projects = Projects::find(array(
            "pi_user_id = :pi_user_id:",
            'bind' => array(
                'pi_user_id' => $pi_user_id
            )
        ));
        // $this->flash->success(var_dump($projects));
        foreach ($projects as $project) {
            // $this->flash->success(var_dump($project));
            if (count($project->Samples) > 0) {
                echo '<li class="list-group-item">';
                echo '	<div class="row">';
                echo '		<div class="col-md-6">';
                echo Tag::linkTo(array(
                    "trackerdetails/showTableSamples/" . $project->id . "?pre=projectPi",
                    $project->name
                ));
                echo '		</div>';
                echo '		<div class="col-md-2">';
                if ($project->ProjectTypes->id > 0) { //Undefined ProjectType->id is -1.
                    echo '          <span>' . $project->ProjectTypes->name . '</span>';
                }
                echo '		</div>';
                echo '		<div class="col-md-1">';
                echo '		</div>';
                echo '		<div class="col-md-1">';
                echo '			<span class="badge">' . Samples::count("project_id = $project->id") . '</span>';
                echo '		</div>';
                echo '		<div class="col-md-2">';
                echo '			<a href="#" rel="tooltip" data-placement="top" data-original-title="Import Excel file"><i class="glyphicon glyphicon-import"></i></a>';
                echo '			<a href="#" rel="tooltip" data-placement="top" data-original-title="Export Excel file"><i class="glyphicon glyphicon-export"></i></a>';
                echo '			<a href="#" rel="tooltip" data-placement="top" data-original-title="Edit Project name"><i class="glyphicon glyphicon-pencil"></i></a>';
                echo '		</div>';
                echo '	</div>';
                echo '</li>';
            }
        }
    }

    /*
    * Build Tracker Project List Items for Experiment Detail
    */
    private $_stepPhaseCodeAction = array(
        'QC' => array(
            'edit' => 'editSamples'
        ),
        'PREP' => array(
            'edit' => 'editSeqlibs'
        )
    );

    public function getTrackerExperimentDetailProjectList($pi_user_id, $nucleotide_type, $step_phase_code, $step_id)
    {
        $pi_user_id = $this->filter->sanitize($pi_user_id, array("int"));
        $nucleotide_type = $this->filter->sanitize($nucleotide_type, array("string"));
        $step_phase_code = $this->filter->sanitize($step_phase_code, array("string"));
        $step_id = $this->filter->sanitize($step_id, array("int"));

        if ($step_phase_code === 'MULTIPLEX' or $step_phase_code === 'DUALMULTIPLEX') {
            $projects = $this->modelsManager->createBuilder()
                ->from('Projects')
                ->join('Seqlibs', 'sl.project_id = Projects.id', 'sl')
                ->join('Protocols', 'pt.id = sl.protocol_id', 'pt')
                ->where('Projects.pi_user_id = :pi_user_id:')
                ->andWhere('Projects.active = "Y"')
                ->andWhere('pt.next_step_phase_code = :next_step_phase_code:')
                ->groupBy('Projects.id')
                ->getQuery()
                ->execute(array(
                    'pi_user_id' => $pi_user_id,
                    'next_step_phase_code' => $step_phase_code
                ));
            // $this->flash->success(var_dump($projects));
            foreach ($projects as $project) {
                // $this->flash->success(var_dump($project));
                // @TODO Should be counted 'active' (in-completed on StepEntries).
                $sample_count = $this->modelsManager->createBuilder()
                    ->addFrom('Seqlibs', 'sl')
                    ->join('Protocols', 'p.id = sl.protocol_id', 'p')
                    ->where('sl.project_id = :project_id:', array('project_id' => $project->id))
                    ->andWhere('p.next_step_phase_code = :next_step_phase_code:', array('next_step_phase_code' => $step_phase_code))
                    ->getQuery()
                    ->execute()
                    ->count();

                if (!$sample_count) {
                    continue;
                }
                echo '  <div class="panel panel-warning">';
                echo '      <div class="panel panel-heading" onclick="showTubeSeqlibs(' . $step_id . ', ' . $project->id . ')">';
                echo '      	<div class="row">';
                echo '	        	<div class="col-md-8">';
                echo '                  <div>' . $project->name . '</div>';
                echo '      		</div>';
                echo '	        	<div class="col-md-1">';
                echo '	        	</div>';
                echo '	        	<div class="col-md-1">';
                echo '		        	<span class="badge">' . $sample_count . '</span>';
                echo '	        	</div>';
                echo '      		<div class="col-md-2">';
                echo '              </div>';
                echo '      	</div>';
                echo '     	</div>';
                echo '      <div id="seqlib-tube-list-project-id-' . $project->id . '">';
                echo '     	</div>';
                echo ' 	</div>';
            }
        } else {
            $projects = Projects::find(array(
                "pi_user_id = :pi_user_id: AND active = 'Y'",
                'bind' => array(
                    'pi_user_id' => $pi_user_id
                )
            ));
            foreach ($projects as $project) {
                // $this->flash->success(var_dump($project));
                if ($step_phase_code == 'QC') {
                    $sample_count = $this->modelsManager->createBuilder()
                        ->addFrom('Samples', 's')
                        ->join('SampleTypes', 'st.id = s.sample_type_id', 'st')
                        ->leftJoin('StepEntries', 'ste.sample_id = s.id AND ste.step_id = :step_id: AND ( ste.status != "Completed" OR ste.status IS NULL )', 'ste')
                        ->where('s.project_id = :project_id:')
                        ->andWhere('st.nucleotide_type = :nucleotide_type:')
                        ->getQuery()
                        ->execute(array(
                            'step_id' => $step_id,
                            'project_id' => $project->id,
                            'nucleotide_type' => $nucleotide_type
                        ))
                        ->count();
                } elseif ($step_phase_code == 'PREP') {
                    $sample_count = $this->modelsManager->createBuilder()
                        ->addFrom('Seqlibs', 'slib')
                        ->leftJoin('StepEntries', 'ste.seqlib_id = slib.id AND ste.step_id = :step_id: AND ( ste.status != "Completed" OR ste.status IS NULL )', 'ste')
                        ->join('Protocols', 'p.id = slib.protocol_id', 'p')
                        ->join('Steps', 'st.id = p.step_id', 'st')
                        ->where('slib.project_id = :project_id:')
                        ->andWhere('st.nucleotide_type = :nucleotide_type:')
                        ->getQuery()
                        ->execute(array(
                            'step_id' => $step_id,
                            'project_id' => $project->id,
                            'nucleotide_type' => $nucleotide_type
                        ))
                        ->count();
                }

                if (!$sample_count) {
                    continue;
                }
                echo '<li class="list-group-item">';
                echo '	<div class="row">';
                echo '		<div class="col-md-8">';
                echo Tag::linkTo(array(
                    "trackerdetails/" . $this->_stepPhaseCodeAction[$step_phase_code]['edit'] . '/' . $step_phase_code . '/' . $step_id . '/' . $project->id,
                    $project->name
                ));
                echo '		</div>';
                echo '		<div class="col-md-1">';
                echo '		</div>';
                echo '		<div class="col-md-1">';
                echo '			<span class="badge">' . $sample_count . '</span>';
                echo '		</div>';
                echo '		<div class="col-md-2">';
                echo '<!--';
                echo '			<a href="#" rel="tooltip" data-placement="top" data-original-title="Import Excel file"><i class="glyphicon glyphicon-import"></i></a>';
                echo '			<a href="#" rel="tooltip" data-placement="top" data-original-title="Export Excel file"><i class="glyphicon glyphicon-export"></i></a>';
                echo '			<a href="#" rel="tooltip" data-placement="top" data-original-title="Edit Project name"><i class="glyphicon glyphicon-pencil"></i></a>';
                echo '-->';
                echo '		</div>';
                echo '	</div>';
                echo '</li>';
            }
        }
    }
}
