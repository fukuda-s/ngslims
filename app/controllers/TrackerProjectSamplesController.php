<?php
use Phalcon\Tag;

class TrackerProjectSamplesController extends ControllerBase {

	public function initialize() {
		$this->view->setTemplateAfter('main');
		Tag::setTitle('Manage your product samples');
		parent::initialize();
	}

	public function indexAction( $project_id ) {
		$project_id = $this->filter->sanitize($project_id, array (
				"int"
		));
		// $this->flash->success(var_dump($users));
		// $this->flash->success($project_id);

		$samples = Samples::find(array (
				"project_id=:project_id:",
				'bind' => array (
						'project_id' => $project_id
				)
		));
		$this->view->setVar('samples', $samples);

		$project = $samples[0]->Projects;
		$this->view->setVar('project', $project);

		// $this->flash->success($project->users->name . " " . $project->name);
		//$this->flash->success(var_dump($samples[0]->seqlibs[0]->seqtemplates[0]));
	}
}