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

	/**
	 * Independent Column Mapping.
	 */
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
