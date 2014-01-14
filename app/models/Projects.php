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

	public function setId( $id ) {
		$this->id = $id;
		return $this;
	}

	public function setLabId( $lab_id ) {
		$this->lab_id = $lab_id;
		return $this;
	}

	public function setName( $name ) {
		$this->name = $name;
		return $this;
	}

	public function setUserId( $user_id ) {
		$this->user_id = $user_id;
		return $this;
	}

	public function setCreateAt( $create_at ) {
		$this->create_at = $create_at;
		return $this;
	}

	public function setDescription( $description ) {
		$this->description = $description;
		return $this;
	}

	public function getId() {
		return $this->id;
	}

	public function getLabId() {
		return $this->lab_id;
	}

	public function getName() {
		return $this->name;
	}

	public function getUserId() {
		return $this->user_id;
	}

	public function getCreateAt() {
		return $this->create_at;
	}

	public function getDescription() {
		return $this->description;
	}

	public function getLabs() {
		return $this->getRelated('Labs');
	}

	public function getUsers($parameters=null) {
		return $this->getRelated('Users', $parameters);
	}

	public function initialize() {
		$this->belongsTo('lab_id', 'Labs', 'id');
		$this->belongsTo('user_id', 'Users', 'id');

		$this->hasMany('id', 'Samples', 'project_id');
	}
}
