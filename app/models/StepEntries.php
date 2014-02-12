<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;

class StepEntries extends \Phalcon\Mvc\Model
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
    public $sample_id;

    /**
     *
     * @var string
     */
    public $step_phase_code;

    /**
     *
     * @var integer
     */
    public $step_id;

    /**
     *
     * @var integer
     */
    public $protocol_id;

    /**
     *
     * @var integer
     */
    public $seq_run_type_scheme_id;

    /**
     *
     * @var string
     */
    public $started_at;

    /**
     *
     * @var string
     */
    public $finished_at;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     *
     * @var string
     */
    public $note;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'sample_id' => 'sample_id',
            'step_id' => 'step_id',
            'step_phase_code' => 'step_phase_code',
            'protocol_id' => 'protocol_id',
            'seq_run_type_scheme_id' => 'seq_run_type_scheme_id',
            'started_at' => 'started_at',
            'finished_at' => 'finished_at',
            'created_at' => 'created_at',
            'note' => 'note'
        );
    }

    public function initialize()
    {
        $this->addBehavior(new Timestampable(
            array(
                'beforeValidationOnCreate' => array(
                    'field' => 'created_at',
                    'format' => 'Y-m-d H:i:s'
                )
            )
        ));
    }
}
