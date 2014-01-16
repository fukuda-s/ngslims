<?php

class SamplePropertyTypes extends \Phalcon\Mvc\Model {

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
	public $mo_term_name;

	/**
	 *
	 * @var string
	 */
	public $mo_id;

	/**
	 *
	 * @var string
	 */
	public $active;

	/**
	 * Independent Column Mapping.
	 */
	public function columnMap() {
		return array (
				'id' => 'id',
				'name' => 'name',
				'mo_term_name' => 'mo_term_name',
				'mo_id' => 'mo_id',
				'active' => 'active'
		);
	}
}
