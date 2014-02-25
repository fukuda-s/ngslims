<?php
use Phalcon\Mvc\Model\Behavior\Timestampable;

class Flowcells extends \Phalcon\Mvc\Model
{

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
    public $seq_run_type_scheme_id;

    /**
     *
     * @var integer
     */
    public $run_number;

    /**
     *
     * @var integer
     */
    public $instrument_id;

    /**
     *
     * @var string
     */
    public $side;

    /**
     *
     * @var string
     */
    public $dirname;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     *
     * @var string
     */
    public $notes;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'name' => 'name',
            'seq_run_type_scheme_id' => 'seq_run_type_scheme_id',
            'run_number' => 'run_number',
            'instrument_id' => 'instrument_id',
            'side' => 'side',
            'dirname' => 'dirname',
            'created_at' => 'created_at',
            'notes' => 'notes'
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
