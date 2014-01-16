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

	public function setId( $id ) {
		$this->id = $id;
		return $this;
	}

	public function setName( $name ) {
		$this->name = $name;
		return $this;
	}

	public function setSampleId( $sample_id ) {
		$this->sample_id = $sample_id;
		return $this;
	}

	public function setRequestId( $request_id ) {
		$this->request_id = $request_id;
		return $this;
	}

	public function setSeqlibProtocolId( $seqlib_protocol_id ) {
		$this->seqlib_protocol_id = $seqlib_protocol_id;
		return $this;
	}

	public function setOligobarcodeaId( $oligobarcodeA_id ) {
		$this->oligobarcodeA_id = $oligobarcodeA_id;
		return $this;
	}

	public function setOligobarcodebId( $oligobarcodeB_id ) {
		$this->oligobarcodeB_id = $oligobarcodeB_id;
		return $this;
	}

	public function setBioanalyserChipCode( $bioanalyser_chip_code ) {
		$this->bioanalyser_chip_code = $bioanalyser_chip_code;
		return $this;
	}

	public function setConcentration( $concentration ) {
		$this->concentration = $concentration;
		return $this;
	}

	public function setStockSeqlibVolume( $stock_seqlib_volume ) {
		$this->stock_seqlib_volume = $stock_seqlib_volume;
		return $this;
	}

	public function setFragmentSize( $fragment_size ) {
		$this->fragment_size = $fragment_size;
		return $this;
	}

	public function setCreateAt( $create_at ) {
		$this->create_at = $create_at;
		return $this;
	}

	public function getId() {
		return $this->id;
	}

	public function getName() {
		return $this->name;
	}

	public function getSampleId() {
		return $this->sample_id;
	}

	public function getRequestId() {
		return $this->request_id;
	}

	public function getSeqlibProtocolId() {
		return $this->seqlib_protocol_id;
	}

	public function getOligobarcodeaId() {
		return $this->oligobarcodeA_id;
	}

	public function getOligobarcodebId() {
		return $this->oligobarcodeB_id;
	}

	public function getBioanalyserChipCode() {
		return $this->bioanalyser_chip_code;
	}

	public function getConcentration() {
		return $this->concentration;
	}

	public function getStockSeqlibVolume() {
		return $this->stock_seqlib_volume;
	}

	public function getFragmentSize() {
		return $this->fragment_size;
	}

	public function getCreateAt() {
		return $this->create_at;
	}

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
