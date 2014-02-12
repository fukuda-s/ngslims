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
            'action' => 'project'
        ),
        'QC Experiment View' => array(
            'controller' => 'tracker',
            'action' => 'qcExperiment'
        ),
        'Indexing and Multiplexing View' => array(
            'controller' => 'tracker',
            'action' => 'seqlibExperiment'
        ),
        'Sequencing View' => array(
            'controller' => 'tracker',
            'action' => 'sequence'
        ),
        'hr',
        'Protocol Setting' => array(
            'controller' => 'tracker',
            'action' => 'protocol'
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
        echo '<ul class="nav nav-pills nav-stacked" data-spy="affix" data-offset-top="50" data-target="#">';
        // echo '<ul class="nav nav-pills nav-stacked">';
        foreach ($this->_trackerSideMenu as $caption => $option) {
            if ($caption == 'hr') {
                echo '<hr />';
                continue;
            } elseif ($option['controller'] == $controllerName && ($option['action'] == $actionName)) {
                echo '<li class="active">';
            } else {
                echo '<li>';
            }
            echo Tag::linkTo($option['controller'] . '/' . $option['action'], $caption), '<li>';
        }
        echo '</ul>';
    }

    /*
     * Build Tracker Project List Items
     */
    public function getTrackerProjectList($user_id)
    {
        $projects = Projects::find(array(
            "user_id=:user_id:",
            'bind' => array(
                'user_id' => $user_id
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
}
