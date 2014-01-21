<?php
use Phalcon\Tag;
use Phalcon\Logger\Formatter\Json;

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

		/*
		 * Get Project table from related $samples[0], because all sample array has same Project.
		 */
		$project = $samples[0]->Projects;
		$this->view->setVar('project', $project);

		// $this->flash->success($project->users->name . " " . $project->name);
		// $this->flash->success(var_dump($samples[0]->seqlibs[0]->seqtemplates[0]));
	}

	public function editSamplesAction( $project_id ) {
		$project_id = $this->filter->sanitize($project_id, array (
				"int"
		));
		$this->view->setVar('project', Projects::findFirstById($project_id));
		// $this->flash->success("TEST");
	}

	public function saveSamplesAction() {
		$this->view->disable();
		$request = new \Phalcon\Http\Request();
		// Check whether the request was made with method POST
		if ( $request->isPost() == true ) {
			// Check whether the request was made with Ajax
			if ( $request->isAjax() == true ) {
				// echo "Request was made using POST and AJAX";
				if ( $request->hasPost('data') && $request->hasPost('changes') ) {
					$changes = $request->getPost('changes');
					$data = $request->getPost('data');

					foreach ( $changes as $key => $value ) {
						$rowNumToChange = $value[0];
						$colNameToChange = $value[1];
						$valueToChange = ( intval($value[3]) === 0 ) ? NULL : $value[3];
						$sample_id = $data[$rowNumToChange]["id"];

						$samples = Samples::findFirst("id = $sample_id");
						$samples->$colNameToChange = $valueToChange;
						if ( ! $samples->save() ) {
							foreach ( $samples->getMessages() as $message ) {
								$this->flash->error((string) $message);
							}
							return;
						}
					}
					// Something return is necessary for frontend jQuery Ajax to find success or fail.
					echo json_encode($changes);
				}
			}
		}
	}
}