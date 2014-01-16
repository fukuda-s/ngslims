<?php

class SamplePropertyEntries extends \Phalcon\Mvc\Model {

	/**
	 *
	 * @var integer
	 */
	public $id;

	/**
	 *
	 * @var integer
	 */
	public $sample_property_type_id;

	/**
	 *
	 * @var integer
	 */
	public $sample_id;

	/**
	 *
	 * @var string
	 */
	public $value;

	public function setId( $id ) {
		$this->id = $id;
		return $this;
	}

	public function setSamplePropertyTypeId( $sample_property_type_id ) {
		$this->sample_property_type_id = $sample_property_type_id;
		return $this;
	}

	public function setSampleId( $sample_id ) {
		$this->sample_id = $sample_id;
		return $this;
	}

	public function setValue( $value ) {
		$this->value = $value;
		return $this;
	}

	public function getId() {
		return $this->id;
	}

	public function getSamplePropertyTypeId() {
		return $this->sample_property_type_id;
	}

	public function getSampleId() {
		return $this->sample_id;
	}

	public function getValue() {
		return $this->value;
	}

	public function columnMap() {
		return array (
				'id' => 'id',
				'sample_property_type_id' => 'sample_property_type_id',
				'sample_id' => 'sample_id',
				'value' => 'value'
		);
	}
}
