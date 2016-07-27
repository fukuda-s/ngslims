<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;

class Seqlanes extends \Phalcon\Mvc\Model
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
    public $number;

    /**
     *
     * @var integer
     */
    public $flowcell_id;

    /**
     *
     * @var integer
     */
    public $seqtemplate_id;

    /**
     *
     * @var integer
     */
    public $number_sequencing_cycles_actual;

    /**
     *
     * @var string
     */
    public $filename;

    /**
     *
     * @var string
     */
    public $first_cycle_date;

    /**
     *
     * @var string
     */
    public $last_cycle_date;

    /**
     *
     * @var string
     */
    public $last_cycle_completed;

    /**
     *
     * @var string
     */
    public $last_cycle_failed;

    /**
     *
     * @var double
     */
    public $apply_conc;

    /**
     *
     * @var string
     */
    public $is_control;

    /**
     *
     * @var integer
     */
    public $control_id;

    /**
     *
     * @var double
     */
    public $q30_percent;

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
     *
     * @var integer
     */
    public $intensity;

    /**
     *
     * @var integer
     */
    public $intensity_sd;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'number' => 'number',
            'flowcell_id' => 'flowcell_id',
            'seqtemplate_id' => 'seqtemplate_id',
            'number_sequencing_cycles_actual' => 'number_sequencing_cycles_actual',
            'filename' => 'filename',
            'first_cycle_date' => 'first_cycle_date',
            'last_cycle_date' => 'last_cycle_date',
            'last_cycle_completed' => 'last_cycle_completed',
            'last_cycle_failed' => 'last_cycle_failed',
            'apply_conc' => 'apply_conc',
            'is_control' => 'is_control',
            'control_id' => 'control_id',
            'q30_percent' => 'q30_percent',
            'reads_total' => 'reads_total',
            'reads_passed_filter' => 'reads_passed_filter',
            'intensity' => 'intensity',
            'intensity_sd' => 'intensity_sd',
            'created_at' => 'created_at'
        );
    }

    public function initialize()
    {
        $this->belongsTo('flowcell_id', 'Flowcells', 'id');
        $this->belongsTo('seqtemplate_id', 'Seqtemplates', 'id');
        $this->belongsTo('control_id', 'Controls', 'id');

        $this->hasMany('id', 'SeqDemultiplexResults', 'seqlane_id');

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
