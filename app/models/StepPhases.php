<?php

class StepPhases extends \Phalcon\Mvc\Model {

	/**
	 *
	 * @var string
	 */
	public $step_phase_code;

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
				'step_phase_code' => 'step_phase_code',
				'sort_order' => 'sort_order',
				'active' => 'active'
		);
	}
}
