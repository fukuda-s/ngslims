<?php

class Instruments extends \Phalcon\Mvc\Model {

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
	public $instrument_number;

	/**
	 *
	 * @var string
	 */
	public $nickname;

	/**
	 *
	 * @var integer
	 */
	public $instrument_type_id;

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
				'instrument_number' => 'instrument_number',
				'nickname' => 'nickname',
				'instrument_type_id' => 'instrument_type_id',
				'active' => 'active'
		);
	}
}
