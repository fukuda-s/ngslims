<?php

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
    public $seq_runmode_type_id;

    /**
     *
     * @var integer
     */
    public $seq_runread_type_id;

    /**
     *
     * @var integer
     */
    public $seq_runcycle_type_id;

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
    public $create_at;

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
            'seq_runmode_type_id' => 'seq_runmode_type_id',
            'seq_runread_type_id' => 'seq_runread_type_id',
            'seq_runcycle_type_id' => 'seq_runcycle_type_id',
            'run_number' => 'run_number',
            'instrument_id' => 'instrument_id',
            'side' => 'side',
            'dirname' => 'dirname',
            'create_at' => 'create_at',
            'notes' => 'notes'
        );
    }
}
