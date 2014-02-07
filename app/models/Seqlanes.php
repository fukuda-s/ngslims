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
     * @var double
     */
    public $q30_yield;

    /**
     *
     * @var double
     */
    public $q30_percent;

    /**
     *
     * @var integer
     */
    public $read1_clusters_total;

    /**
     *
     * @var integer
     */
    public $read1_clusters_passed_filter;

    /**
     *
     * @var integer
     */
    public $read2_clusters_total;

    /**
     *
     * @var integer
     */
    public $read2_clusters_passed_filter;

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
            'q30_yield' => 'q30_yield',
            'q30_percent' => 'q30_percent',
            'read1_clusters_total' => 'read1_clusters_total',
            'read1_clusters_passed_filter' => 'read1_clusters_passed_filter',
            'read2_clusters_total' => 'read2_clusters_total',
            'read2_clusters_passed_filter' => 'read2_clusters_passed_filter',
            'created_at' => 'created_at'
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
                )
            )
        ));
    }
}
