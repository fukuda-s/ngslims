<?php
use Phalcon\Tag, ngsLIMS\Models\Project;
use Phalcon\Acl;

class TrackerController extends ControllerBase {

	public function initialize() {
		$this->view->setTemplateAfter('main');
		Tag::setTitle('Sample Tracker');
		parent::initialize();
	}

	public function indexAction() {
	}

	public function projectAction() {
		Tag::appendTitle(' | Projects ');

		/* Get PI list and data */
		$phql = 'SELECT
					COUNT(DISTINCT p.id) AS project_count,
					COUNT(DISTINCT s.id) AS sample_count,
					u.id,
					u.name
                 FROM
					Users u,
					Projects p,
					Samples s
				WHERE
					u.id = p.user_id AND p.id = s.project_id
				GROUP BY (u.id)';
		$users = $this->modelsManager->executeQuery($phql);

		//$this->flash->success(var_dump($users));
		$this->view->setVar('users', $users);
	}

	public function experimentAction() {
		Tag::appendTitle(' | Experiments ');
	}

	public function protocolAction() {
		Tag::appendTitle(' | Protocols ');
	}
}
