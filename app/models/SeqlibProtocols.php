<?php

class SeqlibProtocols extends \Phalcon\Mvc\Model {

	/**
	 *
	 * @var integer
	 */
	public $id;

	/**
	 *
	 * @var string
	 */
	public $name;

	/**
	 *
	 * @var string
	 */
	public $description;

	/**
	 *
	 * @var string
	 */
	public $create_at;

	/**
	 *
	 * @var string
	 */
	public $active;

	public function setId( $id ) {
		$this->id = $id;
		return $this;
	}

	public function setName( $name ) {
		$this->name = $name;
		return $this;
	}

	public function setDescription( $description ) {
		$this->description = $description;
		return $this;
	}

	public function setCreateAt( $create_at ) {
		$this->create_at = $create_at;
		return $this;
	}

	public function setActive( $active ) {
		$this->active = $active;
		return $this;
	}

	public function getId() {
		return $this->id;
	}

	public function getName() {
		return $this->name;
	}

	public function getDescription() {
		return $this->description;
	}

	public function getCreateAt() {
		return $this->create_at;
	}

	public function getActive() {
		return $this->active;
	}

	/**
	 * Independent Column Mapping.
	 */
	public function columnMap() {
		return array (
				'id' => 'id',
				'name' => 'name',
				'description' => 'description',
				'create_at' => 'create_at',
				'active' => 'active'
		);
	}
}
