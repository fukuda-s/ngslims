<?php

class Requests extends \Phalcon\Mvc\Model {

	/**
	 *
	 * @var integer
	 */
	public $id;

	/**
	 *
	 * @var integer
	 */
	public $project_id;

	/**
	 *
	 * @var integer
	 */
	public $lab_id;

	/**
	 *
	 * @var integer
	 */
	public $user_id;

	/**
	 *
	 * @var string
	 */
	public $create_at;

	/**
	 *
	 * @var string
	 */
	public $description;

	/**
	 * Independent Column Mapping.
	 */
	public function columnMap() {
		return array (
				'id' => 'id',
				'project_id' => 'project_id',
				'lab_id' => 'lab_id',
				'user_id' => 'user_id',
				'create_at' => 'create_at',
				'description' => 'description'
		);
	}
}
