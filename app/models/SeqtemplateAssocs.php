<?php

class SeqtemplateAssocs extends \Phalcon\Mvc\Model {

	/**
	 *
	 * @var integer
	 */
	public $id;

	/**
	 *
	 * @var integer
	 */
	public $seqtemplate_id;

	/**
	 *
	 * @var integer
	 */
	public $seqlib_id;

	/**
	 *
	 * @var double
	 */
	public $assoc_factor;

	/**
	 *
	 * @var double
	 */
	public $assoc_vol;

	/**
	 *
	 * @var integer
	 */
	public $reads_total;

	/**
	 *
	 * @var integer
	 */
	public $reads_passed_filter;

	public function setId( $id ) {
		$this->id = $id;
		return $this;
	}

	public function setSeqtemplateId( $seqtemplate_id ) {
		$this->seqtemplate_id = $seqtemplate_id;
		return $this;
	}

	public function setSeqlibId( $seqlib_id ) {
		$this->seqlib_id = $seqlib_id;
		return $this;
	}

	public function setAssocFactor( $assoc_factor ) {
		$this->assoc_factor = $assoc_factor;
		return $this;
	}

	public function setAssocVol( $assoc_vol ) {
		$this->assoc_vol = $assoc_vol;
		return $this;
	}

	public function setReadsTotal( $reads_total ) {
		$this->reads_total = $reads_total;
		return $this;
	}

	public function setReadsPassedFilter( $reads_passed_filter ) {
		$this->reads_passed_filter = $reads_passed_filter;
		return $this;
	}

	public function getId() {
		return $this->id;
	}

	public function getSeqtemplateId() {
		return $this->seqtemplate_id;
	}

	public function getSeqlibId() {
		return $this->seqlib_id;
	}

	public function getAssocFactor() {
		return $this->assoc_factor;
	}

	public function getAssocVol() {
		return $this->assoc_vol;
	}

	public function getReadsTotal() {
		return $this->reads_total;
	}

	public function getReadsPassedFilter() {
		return $this->reads_passed_filter;
	}

	public function columnMap() {
		return array (
				'id' => 'id',
				'seqtemplate_id' => 'seqtemplate_id',
				'seqlib_id' => 'seqlib_id',
				'assoc_factor' => 'assoc_factor',
				'assoc_vol' => 'assoc_vol',
				'reads_total' => 'reads_total',
				'reads_passed_filter' => 'reads_passed_filter'
		);
	}
}
