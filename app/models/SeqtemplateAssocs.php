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
}
