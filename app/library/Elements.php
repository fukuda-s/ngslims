<?php

/**
 * Elements
 *
 * Helps to build UI elements for the application
 */
class Elements extends Phalcon\Mvc\User\Component {

	private $_headerMenu = array (
			'pull-left' => array (
					'index' => array (
							'caption' => 'Home',
							'action' => 'index'
					),
					'tracker' => array (
							'caption' => 'Tracker',
							'action' => 'index'
					),
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
			),
			'pull-right' => array (
					'session' => array (
							'caption' => 'Log In/Sign Up',
							'action' => 'index'
					)
			)
	);

	private $_tabs = array (
			'Invoices' => array (
					'controller' => 'invoices',
					'action' => 'index',
					'any' => false
			),
			'Companies' => array (
					'controller' => 'companies',
					'action' => 'index',
					'any' => true
			),
			'Products' => array (
					'controller' => 'products',
					'action' => 'index',
					'any' => true
			),
			'Product Types' => array (
					'controller' => 'producttypes',
					'action' => 'index',
					'any' => true
			),
			'Your Profile' => array (
					'controller' => 'invoices',
					'action' => 'profile',
					'any' => false
			)
	);

	private $_trackerSideMenu = array (
			'Project Overview' => array (
					'action' => 'project'
			),
			'Experiment View' => array (
					'action' => 'experiment'
			),
			'hr',
			'Protocol Setting' => array (
					'action' => 'protocol'
			)
	);

	/**
	 * Builds header menu with left and right items
	 *
	 * @return string
	 */
	public function getMenu() {
		$auth = $this->session->get('auth');
		if ( $auth ) {
			$this->_headerMenu ['pull-right'] ['session'] = array (
					'caption' => 'Log Out',
					'action' => 'end'
			);
		} else {
			unset($this->_headerMenu ['pull-left'] ['invoices']);
			unset($this->_headerMenu ['pull-left'] ['tracker']);
		}

		echo '<div class="collapse navbar-collapse target">';
		$controllerName = $this->view->getControllerName();
		foreach ( $this->_headerMenu as $position => $menu ) {
			echo '<ul class="nav navbar-nav ', $position, '">';
			foreach ( $menu as $controller => $option ) {
				if ( $controllerName == $controller ) {
					echo '<li class="active">';
				} else {
					echo '<li>';
				}
				echo Phalcon\Tag::linkTo($controller . '/' . $option ['action'], $option ['caption']);
				echo '</li>';
			}
			echo '</ul>';
		}
		// echo '</div>';
	}

	public function getTabs() {
		$controllerName = $this->view->getControllerName();
		$actionName = $this->view->getActionName();
		echo '<ul class="nav nav-tabs">';
		foreach ( $this->_tabs as $caption => $option ) {
			if ( $option ['controller'] == $controllerName && ($option ['action'] == $actionName || $option ['any']) ) {
				echo '<li class="active">';
			} else {
				echo '<li>';
			}
			echo Phalcon\Tag::linkTo($option ['controller'] . '/' . $option ['action'], $caption), '<li>';
		}
		echo '</ul>';
	}

	/*
	 * Bulids side menu for Sample Tracker
	 */
	public function getTrackerSideMenu() {
		$actionName = $this->view->getActionName();
		echo '<ul class="nav nav-pills nav-stacked" data-spy="affix" data-offset-top="100" data-target="#">';
		foreach ( $this->_trackerSideMenu as $caption => $option ) {
			if ( $caption == 'hr' ) {
				echo '<hr />';
				continue;
			} elseif ( $option ['action'] == $actionName ) {
				echo '<li class="active">';
			} else {
				echo '<li>';
			}
			echo Phalcon\Tag::linkTo('tracker/' . $option ['action'], $caption), '<li>';
		}
		echo '</ul>';
	}

	/*
	 * Build Tracker Project List Items
	 */
	public function getTrackerProjectList( $user_id ) {
		$projects = Projects::find(array (
				"user_id=:user_id:",
				'bind' => array (
						'user_id' => $user_id
				)
		));
		// $this->flash->success(var_dump($projects));
		foreach ( $projects as $project ) {
			// $this->flash->success(var_dump($project));
			echo '<li class="list-group-item">';
			echo '	<div class="row">';
			echo '		<div class="col-md-8">';
			echo '			<a href="./projectSamples.php?idProject=83&amp;projectOwner=Aihara&amp;projectName=Brain_tumor">' . $project->name . '</a>';
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
