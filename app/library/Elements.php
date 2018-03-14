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
            'cherrypicking' => array(
                'caption' => 'Cherry Picking',
                'action' => 'index'
            ),
            /*
            'kanban' => array(
                'caption' => 'Kanban',
                'action' => 'index'
            ),
            */
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
            'setting' => array(
                'caption' => 'Setting',
                'action' => 'index'
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
        'Instrument Overview' => array(
            'controller' => 'summary',
            'action' => 'instrument',
            'param' => ''
        ),
        'Overall View' => array(
            'controller' => 'summary',
            'action' => 'overall',
            'param' => ''
        ),
        'hr1' => array(),
        'QC Experiment Setup' => array(
            'controller' => 'tracker',
            'action' => 'experiments',
            'param' => 'QC'
        ),
        'SeqLib Experiment Setup' => array(
            'controller' => 'tracker',
            'action' => 'experiments',
            'param' => 'PREP'
        ),
        'Multiplexing Setup' => array(
            'controller' => 'tracker',
            'action' => 'experiments',
            'param' => 'MULTIPLEX'
        ),
        'Flowcell Setup' => array(
            'controller' => 'tracker',
            'action' => 'experiments',
            'param' => 'FLOWCELL'
        ),
        'Sequencing Setup' => array(
            'controller' => 'tracker',
            'action' => 'sequence',
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
            unset($this->_headerMenu['pull-left']['cherrypicking']);
            unset($this->_headerMenu['pull-left']['kanban']);
            unset($this->_headerMenu['pull-right']['setting']);
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
                    $dropdown = $this->{$option['dropdown']};
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
        $controllerName = $this->dispatcher->getControllerName();
        $actionName = $this->dispatcher->getActionName();
        $paramName = '';
        if ($this->dispatcher->getParams()) {
            $paramName = $this->dispatcher->getParams()[0];
        }
        //echo '<ul class="nav nav-pills nav-stacked" data-spy="affix" data-offset-top="50" data-target="#">';
        echo '<ul class="nav nav-stacked affix">';
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
                    "trackerdetails/showTableSamples/" . $project->id . "?pre_action=projectPi",
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

    public function getTrackerExperimentDetailProjectList($pi_user_id, $step_phase_code, $step_id, $status)
    {
        $pi_user_id = $this->filter->sanitize($pi_user_id, array("int"));
        $step_phase_code = $this->filter->sanitize($step_phase_code, array("string"));
        $step_id = $this->filter->sanitize($step_id, array("int"));
        $status = $this->filter->sanitize($status, array("string"));

        $projects = Projects::find(array(
            "pi_user_id = :pi_user_id: AND active = 'Y'",
            'bind' => array(
                'pi_user_id' => $pi_user_id
            )
        ));
        foreach ($projects as $project) {
            // $this->flash->success(var_dump($project));
            if ($step_phase_code == 'QC') {
                $sample_count_tmp = $this->modelsManager->createBuilder()
                    ->addFrom('Samples', 's')
                    ->join('StepEntries', 'ste.sample_id = s.id AND ste.step_id = :step_id:', 'ste')
                    ->where('s.project_id = :project_id:');
            } elseif ($step_phase_code == 'PREP') {
                $sample_count_tmp = $this->modelsManager->createBuilder()
                    ->addFrom('Seqlibs', 'sl')
                    ->join('StepEntries', 'ste.seqlib_id = sl.id AND ste.step_id = :step_id:', 'ste')
                    ->where('sl.project_id = :project_id:');
            }

            if (is_null($status)) {
                $sample_count_tmp = $sample_count_tmp->andWhere('ste.status IS NULL');
                $status_str = 'NULL';
            } else {
                $sample_count_tmp = $sample_count_tmp->andWhere('ste.status = :status:', array("status" => $status));
                $status_str = $status;
            }
            $sample_count = $sample_count_tmp->getQuery()
                ->execute(array(
                    'step_id' => $step_id,
                    'project_id' => $project->id
                ))
                ->count();

            if (!$sample_count) {
                continue;
            }
            echo '<li class="list-group-item">';
            echo '	<div class="row">';
            echo '		<div class="col-md-8">';
            echo Tag::linkTo(array(
                "trackerdetails/" . $this->_stepPhaseCodeAction[$step_phase_code]['edit'] . '/' . $step_phase_code . '/' . $step_id . '/' . $project->id . '/' . $status_str,
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

    public function getTrackerMultiplexCandidatesProjectList($pi_user_id, $step_phase_code, $step_id)
    {
        $pi_user_id = $this->filter->sanitize($pi_user_id, array("int"));
        $step_phase_code = $this->filter->sanitize($step_phase_code, array("string"));
        $step_id = $this->filter->sanitize($step_id, array("int"));

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
            $seqlib_count = $this->modelsManager->createBuilder()
                ->columns(array(
                    "COUNT(DISTINCT sl.id) AS seqlib_count_all",
                    "COUNT(DISTINCT sta.seqlib_id) AS seqlib_count_used",
                ))
                ->addFrom('Seqlibs', 'sl')
                ->join('Protocols', 'p.id = sl.protocol_id', 'p')
                ->leftJoin('SeqtemplateAssocs', 'sta.seqlib_id = sl.id', 'sta')
                ->where('sl.project_id = :project_id:', array('project_id' => $project->id))
                ->andWhere('p.next_step_phase_code = :next_step_phase_code:', array('next_step_phase_code' => $step_phase_code))
                ->getQuery()
                ->execute()[0];

            if (!$seqlib_count) {
                continue;
            }
            $seqlib_count_unused = $seqlib_count->seqlib_count_all - $seqlib_count->seqlib_count_used;

            if (!$seqlib_count_unused) {
                echo '  <div class="panel panel-default collapse" id="inactives-' . $pi_user_id . '-' . $project->id . '">';
            } else {
                echo '  <div class="panel panel-warning">';
            }
            echo '      <div class="panel panel-heading" onclick="showTubeSeqlibs(' . $step_id . ', ' . $project->id . ', 0)">';
            echo '      	<div class="row">';
            echo '	        	<div class="col-xs-8">';
            echo '                  <div>' . $project->name . '</div>';
            echo '      		</div>';
            echo '	        	<div class="col-xs-1">';
            echo '	        	</div>';
            echo '	        	<div class="col-xs-1">';
            echo '		        	<span class="badge">' . $seqlib_count_unused . '/' . $seqlib_count->seqlib_count_all . '</span>';
            echo '	        	</div>';
            echo '      		<div class="col-xs-2">';
            echo '              </div>';
            echo '      	</div>';
            echo '     	</div>';
            echo '      <div id="seqlib-tube-list-target-id-' . $project->id . '-0">';
            echo '     	</div>';
            echo ' 	</div>';
        }
    }

    public function getMyCherryPickingList()
    {
        $auth = $this->session->get('auth');
        $cherry_pickings = $this->modelsManager->createBuilder()
            ->columns(array('cp.id AS cp_id', 'CONCAT(cp.name, " (", COUNT(cps.id), ") -- ", cp.created_at) AS cp_name'))
            ->addFrom('CherryPickings', 'cp')
            ->leftJoin('CherryPickingSchemes', 'cp.id = cps.cherry_picking_id', 'cps')
            ->where('cp.user_id = :user_id:', array("user_id" => $auth['id']))
            ->groupBy('cp.id')
            ->orderBy('cp.created_at DESC')
            ->getQuery()
            ->execute();

        foreach ($cherry_pickings as $cherry_picking) {
            echo '<li class="list-group-item">' . Tag::linkTo(array("trackerdetails/editSeqlibs/PICK/0/" . $cherry_picking->cp_id, $cherry_picking->cp_name)) . '</li>';
        }

    }

    /**
     * Create random phrase for password
     * @param int $length
     * @return string
     */
    public function random($length = 8)
    {
        return substr(str_shuffle('1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'), 0, $length);
    }
}
