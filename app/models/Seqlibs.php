<?php

class Seqlibs extends \Phalcon\Mvc\Model {

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
	 * @var integer
	 */
	public $sample_id;

	/**
	 *
	 * @var integer
	 */
	public $request_id;

	/**
	 *
	 * @var integer
	 */
	public $seqlib_protocol_id;

	/**
	 *
	 * @var integer
	 */
	public $oligobarcodeA_id;

	/**
	 *
	 * @var integer
	 */
	public $oligobarcodeB_id;

	/**
	 *
	 * @var string
	 */
	public $bioanalyser_chip_code;

	/**
	 *
	 * @var double
	 */
	public $concentration;

	/**
	 *
	 * @var double
	 */
	public $stock_seqlib_volume;

	/**
	 *
	 * @var integer
	 */
	public $fragment_size;

	/**
	 *
	 * @var string
	 */
	public $create_at;

	/**
	 * Independent Column Mapping.
	 */
	public function columnMap() {
		return array (
				'id' => 'id',
				'name' => 'name',
				'sample_id' => 'sample_id',
				'request_id' => 'request_id',
				'seqlib_protocol_id' => 'seqlib_protocol_id',
				'oligobarcodeA_id' => 'oligobarcodeA_id',
				'oligobarcodeB_id' => 'oligobarcodeB_id',
				'bioanalyser_chip_code' => 'bioanalyser_chip_code',
				'concentration' => 'concentration',
				'stock_seqlib_volume' => 'stock_seqlib_volume',
				'fragment_size' => 'fragment_size',
				'create_at' => 'create_at'
		);
	}

	public function initialize() {
		$this->belongsTo('sample_id', 'Samples', 'id');
		$this->belongsTo('request_id', 'Requests', 'id');
		$this->belongsTo('seqlib_protocol_id', 'Protocols', 'id');
		$this->belongsTo('oligobarcodeA_id', 'Oligobarcodes', 'id', array (
				'alias' => 'OligobarcodeA'
		));
		$this->belongsTo('oligobarcodeB_id', 'Oligobarcodes', 'id', array (
				'alias' => 'OligobarcodeB'
		));
		$this->hasManyToMany("id", "SeqtemplateAssocs", "seqlib_id", "seqtemplate_id", "Seqtemplates", "id");
	}
}
