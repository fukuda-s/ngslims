<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;

class Requests extends \Phalcon\Mvc\Model
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
    public $project_id;

    /**
     *
     * @var integer
     */
    public $lab_id;

    /**
     *
     * @var integer
     */
    public $user_id;

    /**
     *
     * @var integer
     */
    public $seq_run_type_scheme_id;

    /**
     *
     * @var integer
     */
    public $samples_per_seqtemplate;

    /**
     *
     * @var integer
     */
    public $lanes_per_seqtemplate;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     *
     * @var string
     */
    public $description;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'project_id' => 'project_id',
            'lab_id' => 'lab_id',
            'user_id' => 'user_id',
            'seq_run_type_scheme_id' => 'seq_run_type_scheme_id',
            'samples_per_seqtemplate' => 'samples_per_seqtemplate',
            'lanes_per_seqtemplate' => 'lanes_per_seqtemplate',
            'created_at' => 'created_at',
            'description' => 'description'
        );
    }

    public function initialize()
    {
        $this->hasMany('id', 'Samples', 'request_id');

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
