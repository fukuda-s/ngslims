<?php

class Projects extends \Phalcon\Mvc\Model {

	/**
	 *
	 * @var integer
	 */
	public $id;

	/**
	 *
	 * @var integer
	 */
	public $lab_id;

	/**
	 *
	 * @var string
	 */
	public $name;

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
				'lab_id' => 'lab_id',
				'name' => 'name',
				'user_id' => 'user_id',
				'create_at' => 'create_at',
				'description' => 'description'
		);
	}

	public function initialize() {
		$this->belongsTo('lab_id', 'Labs', 'id');
		$this->belongsTo('user_id', 'Users', 'id');

		$this->hasMany('id', 'Samples', 'project_id');
	}
}
