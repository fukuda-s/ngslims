<?php

class SamplePropertyEntries extends \Phalcon\Mvc\Model
{

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

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'sample_property_type_id' => 'sample_property_type_id',
            'sample_id' => 'sample_id',
            'value' => 'value'
        );
    }

    public function initialize()
    {
        $this->hasOne('sample_property_type_id', 'SamplePropertyTypes', 'id');
    }
}
