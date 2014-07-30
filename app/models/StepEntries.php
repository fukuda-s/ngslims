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
     * @var integer
     */
    public $seqlib_id;

    /**
     *
     * @var integer
     */
    public $seqtemplate_id;

    /**
     *
     * @var integer
     */
    public $flowcell_id;

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
     * @var string
     */
    public $created_at;

    /**
     *
     * @var string
     */
    public $updated_at;

    /**
     *
     * @var string
     */
    public $status;

    /**
     *
     * @var integer
     */
    public $user_id;

    /**
     *
     * @var integer
     */
    public $update_user_id;

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
            'seqlib_id' => 'seqlib_id',
            'seqtemplate_id' => 'seqtemplate_id',
            'flowcell_id' => 'flowcell_id',
            'step_id' => 'step_id',
            'step_phase_code' => 'step_phase_code',
            'protocol_id' => 'protocol_id',
            'created_at' => 'created_at',
            'updated_at' => 'updated_at',
            'status' => 'status',
            'user_id' => 'user_id',
            'update_user_id' => 'update_user_id',
            'note' => 'note'
        );
    }

    public function initialize()
    {
        $this->belongsTo('flowcell_id', 'Flowcells', 'id');

        $this->addBehavior(new Timestampable(
            array(
                'beforeValidationOnCreate' => array(
                    'field' => 'created_at',
                    'format' => 'Y-m-d H:i:s'
                ),
                'beforeUpdate' => array(
                    'field' => 'updated_at',
                    'format' => 'Y-m-d H:i:s'
                )
            )
        ));
    }
}
