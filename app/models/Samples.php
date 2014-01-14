<?php

class Samples extends \Phalcon\Mvc\Model {

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
	public $request_id;

	/**
	 *
	 * @var integer
	 */
	public $project_id;

	/**
	 *
	 * @var integer
	 */
	public $sample_type_id;

	/**
	 *
	 * @var integer
	 */
	public $organism_id;

	/**
	 *
	 * @var double
	 */
	public $qual_concentration;

	/**
	 *
	 * @var double
	 */
	public $qual_volume;

	/**
	 *
	 * @var double
	 */
	public $qual_amount;

	/**
	 *
	 * @var double
	 */
	public $qual_RIN;

	/**
	 *
	 * @var double
	 */
	public $qual_od260280;

	/**
	 *
	 * @var double
	 */
	public $qual_od260230;

	/**
	 *
	 * @var double
	 */
	public $qual_nanodrop_conc;

	/**
	 *
	 * @var integer
	 */
	public $qual_fragment_size;

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

	public function setName( $name ) {
		$this->name = $name;
		return $this;
	}

	public function setRequestId( $request_id ) {
		$this->request_id = $request_id;
		return $this;
	}

	public function setProjectId( $project_id ) {
		$this->project_id = $project_id;
		return $this;
	}

	public function setSampleTypeId( $sample_type_id ) {
		$this->sample_type_id = $sample_type_id;
		return $this;
	}

	public function setOrganismId( $organism_id ) {
		$this->organism_id = $organism_id;
		return $this;
	}

	public function setQualConcentration( $qual_concentration ) {
		$this->qual_concentration = $qual_concentration;
		return $this;
	}

	public function setQualVolume( $qual_volume ) {
		$this->qual_volume = $qual_volume;
		return $this;
	}

	public function setQualAmount( $qual_amount ) {
		$this->qual_amount = $qual_amount;
		return $this;
	}

	public function setQualRiN( $qual_RIN ) {
		$this->qual_RIN = $qual_RIN;
		return $this;
	}

	public function setQualOd260280( $qual_od260280 ) {
		$this->qual_od260280 = $qual_od260280;
		return $this;
	}

	public function setQualOd260230( $qual_od260230 ) {
		$this->qual_od260230 = $qual_od260230;
		return $this;
	}

	public function setQualNanodropConc( $qual_nanodrop_conc ) {
		$this->qual_nanodrop_conc = $qual_nanodrop_conc;
		return $this;
	}

	public function setQualFragmentSize( $qual_fragment_size ) {
		$this->qual_fragment_size = $qual_fragment_size;
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

	public function getName() {
		return $this->name;
	}

	public function getRequestId() {
		return $this->request_id;
	}

	public function getProjectId() {
		return $this->project_id;
	}

	public function getSampleTypeId() {
		return $this->sample_type_id;
	}

	public function getOrganismId() {
		return $this->organism_id;
	}

	public function getQualConcentration() {
		return $this->qual_concentration;
	}

	public function getQualVolume() {
		return $this->qual_volume;
	}

	public function getQualAmount() {
		return $this->qual_amount;
	}

	public function getQualRiN() {
		return $this->qual_RIN;
	}

	public function getQualOd260280() {
		return $this->qual_od260280;
	}

	public function getQualOd260230() {
		return $this->qual_od260230;
	}

	public function getQualNanodropConc() {
		return $this->qual_nanodrop_conc;
	}

	public function getQualFragmentSize() {
		return $this->qual_fragment_size;
	}

	public function getCreateAt() {
		return $this->create_at;
	}

	public function getDescription() {
		return $this->description;
	}

	public function initialize() {
		$this->hasOne('organism_id', 'Organisms', 'id');
		$this->hasOne('project_id', 'Projects', 'id');
		$this->hasOne('request_id', 'Requests', 'id');
		$this->belongsTo('id', 'SeqLibs', 'sample_id');
	}
}
