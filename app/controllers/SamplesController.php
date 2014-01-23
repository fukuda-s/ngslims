<?php
use Phalcon\Logger\Formatter\Json;

class SamplesController extends ControllerBase {

	public function indexAction() {
		echo "This is index of SamplesController";
	}

	public function loadjsonAction( $project_id ) {
		$this->view->disable();
		$request = new \Phalcon\Http\Request();
		// Check whether the request was made with method POST
		if ( $request->isPost() == true ) {
			// Check whether the request was made with Ajax
			if ( $request->isAjax() == true ) {
				// echo "Request was made using POST and AJAX";
				$project_id = $this->filter->sanitize($project_id, array (
						"int"
				));

				$samples = Samples::find(array (
						"project_id = :project_id:",
						'bind' => array (
								'project_id' => $project_id
						)
				));
				//echo json_encode($this->handsontableHelper->getValuesArr($samples->toArray()));
				echo json_encode($samples->toArray());
			}
		}
	}
}
