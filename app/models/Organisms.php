<?php

class Organisms extends \Phalcon\Mvc\Model {

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
	public $taxonomy;

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

	public function setTaxonomy( $taxonomy ) {
		$this->taxonomy = $taxonomy;
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

	public function getTaxonomy() {
		return $this->taxonomy;
	}

	public function getActive() {
		return $this->active;
	}

	public function columnMap() {
		return array (
				'id' => 'id',
				'name' => 'name',
				'taxonomy' => 'taxonomy',
				'active' => 'active'
		);
	}
}
