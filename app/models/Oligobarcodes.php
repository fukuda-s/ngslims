<?php

class Oligobarcodes extends \Phalcon\Mvc\Model {

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
	public $barcode_seq;

	/**
	 *
	 * @var integer
	 */
	public $oligobarcode_scheme_id;

	/**
	 *
	 * @var integer
	 */
	public $sort_order;

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
				'barcode_seq' => 'barcode_seq',
				'oligobarcode_scheme_id' => 'oligobarcode_scheme_id',
				'sort_order' => 'sort_order',
				'active' => 'active'
		);
	}
}
