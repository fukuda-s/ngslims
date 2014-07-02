<?php


class StepInstrumentTypeSchemes extends \Phalcon\Mvc\Model
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
    public $step_id;

    /**
     *
     * @var integer
     */
    public $instrument_type_id;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'step_id' => 'step_id',
            'instrument_type_id' => 'instrument_type_id'
        );
    }

}
