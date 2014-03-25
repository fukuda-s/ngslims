<?php
use Phalcon\Tag;

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
            ),
            /*
            'invoices' => array (
                    'caption' => 'Invoices',
                    'action' => 'index'
            ),
            'about' => array (
                    'caption' => 'About',
                    'action' => 'index'
            ),
            'contact' => array (
                    'caption' => 'Contact',
                    'action' => 'index'
            )
            */
        ),
        'pull-right' => array(
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

    private $_tabs = array(
        'Invoices' => array(
            'controller' => 'invoices',
            'action' => 'index',
            'any' => false
        ),
        'Companies' => array(
            'controller' => 'companies',
            'action' => 'index',
            'any' => true
        ),
        'Products' => array(
            'controller' => 'products',
            'action' => 'index',
            'any' => true
        ),
        'Product Types' => array(
            'controller' => 'producttypes',
            'action' => 'index',
            'any' => true
        ),
        'Your Profile' => array(
            'controller' => 'invoices',
            'action' => 'profile',
            'any' => false
        )
    );

    private $_trackerSideMenu = array(
        'Project Overview' => array(
            'controller' => 'tracker',
            'action' => 'project',
            'param' => ''
        ),
        'Operation Overview' => array(
            'controller' => 'tracker',
            'action' => 'operation',
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
            'action' => 'flowcell',
            'param' => ''
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
                'caption' => 'Log Out',
                'action' => 'end'
            );
        } else {
            unset($this->_headerMenu['pull-left']['invoices']);
            unset($this->_headerMenu['pull-left']['order']);
            unset($this->_headerMenu['pull-left']['tracker']);
        }

        $controllerName = $this->view->getControllerName();
        foreach ($this->_headerMenu as $position => $menu) {
            echo '<ul class="nav navbar-nav ', $position, '">';
            foreach ($menu as $controller => $option) {
                if ($controllerName == $controller) {
                    echo '<li class="active">';
                } else {
                    echo '<li>';
                }
                echo Tag::linkTo($controller . '/' . $option['action'], $option['caption']);
                echo '</li>';
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
            echo '<li class="list-group-item">';
            echo '	<div class="row">';
            echo '		<div class="col-md-8">';
            echo Tag::linkTo(array(
                "trackerProjectSamples/showTableSamples/" . $project->id,
                $project->name
            ));
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
        $this->filter->sanitize($pi_user_id, array("int"));
        $this->filter->sanitize($nucleotide_type, array("string"));
        $this->filter->sanitize($step_phase_code, array("string"));
        $this->filter->sanitize($step_id, array("int"));

        if ($step_phase_code === 'MULTIPLEX' or $step_phase_code === 'DUALMULTIPLEX') {
            $projects = $this->modelsManager->createBuilder()
                ->From('Projects')
                ->Join('Seqlibs', 'sl.project_id = Projects.id', 'sl')
                ->Join('Protocols', 'pt.id = sl.protocol_id', 'pt')
                ->Where('Projects.pi_user_id = :pi_user_id:')
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
                    ->From('Samples')
                    ->join('Seqlibs', 'sl.sample_id = Samples.id', 'sl')
                    ->join('Protocols', 'p.id = sl.protocol_id', 'p')
                    ->where('Samples.project_id = :project_id:', array('project_id' => $project->id))
                    ->andWhere('p.next_step_phase_code = :next_step_phase_code:', array('next_step_phase_code' => $step_phase_code))
                    ->getQuery()
                    ->execute()
                    ->count();

                if (!$sample_count) {
                    continue;
                }
                echo '  <div class="panel panel-warning">';
                echo '      <div class="panel panel-heading" onclick="showTubeSeqLibs(' . $step_id . ', ' . $project->id . ')">';
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
                "pi_user_id = :pi_user_id:",
                'bind' => array(
                    'pi_user_id' => $pi_user_id
                )
            ));
            foreach ($projects as $project) {
                // $this->flash->success(var_dump($project));
                // @TODO Should be counted 'active' (in-completed on StepEntries).
                $sample_count = $this->modelsManager->createBuilder()
                    ->From('Samples')
                    ->join('SampleTypes', 'st.id = Samples.sample_type_id', 'st')
                    ->where('project_id = :project_id: AND st.nucleotide_type = :nucleotide_type:')
                    ->getQuery()
                    ->execute(array(
                        'project_id' => $project->id,
                        'nucleotide_type' => $nucleotide_type
                    ))
                    ->count();

                if (!$sample_count) {
                    continue;
                }
                echo '<li class="list-group-item">';
                echo '	<div class="row">';
                echo '		<div class="col-md-8">';
                echo Tag::linkTo(array(
                    "trackerProjectSamples/" . $this->_stepPhaseCodeAction[$step_phase_code]['edit'] . '/' . $step_phase_code . '/' . $step_id . '/' . $project->id,
                    $project->name
                ));
                echo '		</div>';
                echo '		<div class="col-md-1">';
                echo '		</div>';
                echo '		<div class="col-md-1">';
                echo '			<span class="badge">' . $sample_count . '</span>';
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
}
