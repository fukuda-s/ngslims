<?php

class Seqlanes extends \Phalcon\Mvc\Model {

	/**
	 *
	 * @var integer
	 */
	public $id;

	/**
	 *
	 * @var integer
	 */
	public $number;

	/**
	 *
	 * @var integer
	 */
	public $flowcell_id;

	/**
	 *
	 * @var integer
	 */
	public $seqtemplate_id;

	/**
	 *
	 * @var integer
	 */
	public $number_sequencing_cycles_actual;

	/**
	 *
	 * @var string
	 */
	public $filename;

	/**
	 *
	 * @var string
	 */
	public $first_cycle_date;

	/**
	 *
	 * @var string
	 */
	public $last_cycle_date;

	/**
	 *
	 * @var string
	 */
	public $last_cycle_completed;

	/**
	 *
	 * @var string
	 */
	public $last_cycle_failed;

	/**
	 *
	 * @var double
	 */
	public $apply_conc;

	/**
	 *
	 * @var string
	 */
	public $is_control;

	/**
	 *
	 * @var double
	 */
	public $q30_yield;

	/**
	 *
	 * @var double
	 */
	public $q30_percent;

	/**
	 *
	 * @var integer
	 */
	public $read1_clusters_total;

	/**
	 *
	 * @var integer
	 */
	public $read1_clusters_passed_filter;

	/**
	 *
	 * @var integer
	 */
	public $read2_clusters_total;

	/**
	 *
	 * @var integer
	 */
	public $read2_clusters_passed_filter;

	public function setId( $id ) {
		$this->id = $id;
		return $this;
	}

	public function setNumber( $number ) {
		$this->number = $number;
		return $this;
	}

	public function setFlowcellId( $flowcell_id ) {
		$this->flowcell_id = $flowcell_id;
		return $this;
	}

	public function setSeqtemplateId( $seqtemplate_id ) {
		$this->seqtemplate_id = $seqtemplate_id;
		return $this;
	}

	public function setNumberSequencingCyclesActual( $number_sequencing_cycles_actual ) {
		$this->number_sequencing_cycles_actual = $number_sequencing_cycles_actual;
		return $this;
	}

	public function setFilename( $filename ) {
		$this->filename = $filename;
		return $this;
	}

	public function setFirstCycleDate( $first_cycle_date ) {
		$this->first_cycle_date = $first_cycle_date;
		return $this;
	}

	public function setLastCycleDate( $last_cycle_date ) {
		$this->last_cycle_date = $last_cycle_date;
		return $this;
	}

	public function setLastCycleCompleted( $last_cycle_completed ) {
		$this->last_cycle_completed = $last_cycle_completed;
		return $this;
	}

	public function setLastCycleFailed( $last_cycle_failed ) {
		$this->last_cycle_failed = $last_cycle_failed;
		return $this;
	}

	public function setApplyConc( $apply_conc ) {
		$this->apply_conc = $apply_conc;
		return $this;
	}

	public function setIsControl( $is_control ) {
		$this->is_control = $is_control;
		return $this;
	}

	public function setQ30Yield( $q30_yield ) {
		$this->q30_yield = $q30_yield;
		return $this;
	}

	public function setQ30Percent( $q30_percent ) {
		$this->q30_percent = $q30_percent;
		return $this;
	}

	public function setRead1ClustersTotal( $read1_clusters_total ) {
		$this->read1_clusters_total = $read1_clusters_total;
		return $this;
	}

	public function setRead1ClustersPassedFilter( $read1_clusters_passed_filter ) {
		$this->read1_clusters_passed_filter = $read1_clusters_passed_filter;
		return $this;
	}

	public function setRead2ClustersTotal( $read2_clusters_total ) {
		$this->read2_clusters_total = $read2_clusters_total;
		return $this;
	}

	public function setRead2ClustersPassedFilter( $read2_clusters_passed_filter ) {
		$this->read2_clusters_passed_filter = $read2_clusters_passed_filter;
		return $this;
	}

	public function getId() {
		return $this->id;
	}

	public function getNumber() {
		return $this->number;
	}

	public function getFlowcellId() {
		return $this->flowcell_id;
	}

	public function getSeqtemplateId() {
		return $this->seqtemplate_id;
	}

	public function getNumberSequencingCyclesActual() {
		return $this->number_sequencing_cycles_actual;
	}

	public function getFilename() {
		return $this->filename;
	}

	public function getFirstCycleDate() {
		return $this->first_cycle_date;
	}

	public function getLastCycleDate() {
		return $this->last_cycle_date;
	}

	public function getLastCycleCompleted() {
		return $this->last_cycle_completed;
	}

	public function getLastCycleFailed() {
		return $this->last_cycle_failed;
	}

	public function getApplyConc() {
		return $this->apply_conc;
	}

	public function getIsControl() {
		return $this->is_control;
	}

	public function getQ30Yield() {
		return $this->q30_yield;
	}

	public function getQ30Percent() {
		return $this->q30_percent;
	}

	public function getRead1ClustersTotal() {
		return $this->read1_clusters_total;
	}

	public function getRead1ClustersPassedFilter() {
		return $this->read1_clusters_passed_filter;
	}

	public function getRead2ClustersTotal() {
		return $this->read2_clusters_total;
	}

	public function getRead2ClustersPassedFilter() {
		return $this->read2_clusters_passed_filter;
	}

	public function columnMap() {
		return array (
				'id' => 'id',
				'number' => 'number',
				'flowcell_id' => 'flowcell_id',
				'seqtemplate_id' => 'seqtemplate_id',
				'number_sequencing_cycles_actual' => 'number_sequencing_cycles_actual',
				'filename' => 'filename',
				'first_cycle_date' => 'first_cycle_date',
				'last_cycle_date' => 'last_cycle_date',
				'last_cycle_completed' => 'last_cycle_completed',
				'last_cycle_failed' => 'last_cycle_failed',
				'apply_conc' => 'apply_conc',
				'is_control' => 'is_control',
				'q30_yield' => 'q30_yield',
				'q30_percent' => 'q30_percent',
				'read1_clusters_total' => 'read1_clusters_total',
				'read1_clusters_passed_filter' => 'read1_clusters_passed_filter',
				'read2_clusters_total' => 'read2_clusters_total',
				'read2_clusters_passed_filter' => 'read2_clusters_passed_filter'
		);
	}
}
