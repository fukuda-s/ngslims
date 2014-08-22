<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;

class Seqlibs extends \Phalcon\Mvc\Model
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
    public $sample_id;

    /**
     *
     * @var integer
     */
    public $project_id;

    /**
     *
     * @var integer
     */
    public $protocol_id;

    /**
     *
     * @var integer
     */
    public $oligobarcodeA_id;

    /**
     *
     * @var integer
     */
    public $oligobarcodeB_id;

    /**
     *
     * @var string
     */
    public $bioanalyser_chip_code;

    /**
     *
     * @var double
     */
    public $concentration;

    /**
     *
     * @var double
     */
    public $stock_seqlib_volume;

    /**
     *
     * @var integer
     */
    public $fragment_size;

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
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'name' => 'name',
            'sample_id' => 'sample_id',
            'project_id' => 'project_id',
            'protocol_id' => 'protocol_id',
            'oligobarcodeA_id' => 'oligobarcodeA_id',
            'oligobarcodeB_id' => 'oligobarcodeB_id',
            'bioanalyser_chip_code' => 'bioanalyser_chip_code',
            'concentration' => 'concentration',
            'stock_seqlib_volume' => 'stock_seqlib_volume',
            'fragment_size' => 'fragment_size',
            'started_at' => 'started_at',
            'finished_at' => 'finished_at',
            'created_at' => 'created_at'
        );
    }

    public function initialize()
    {
        $this->belongsTo('sample_id', 'Samples', 'id');
        $this->belongsTo('project_id', 'Projects', 'id');
        $this->belongsTo('protocol_id', 'Protocols', 'id');
        $this->belongsTo('oligobarcodeA_id', 'Oligobarcodes', 'id', array(
            'alias' => 'OligobarcodeA'
        ));
        $this->belongsTo('oligobarcodeB_id', 'Oligobarcodes', 'id', array(
            'alias' => 'OligobarcodeB'
        ));

        $this->hasMany('id', 'StepEntries', 'seqlib_id'); //It should be hasMany to use tied record on order.

        $this->hasManyToMany("id", "SeqtemplateAssocs", "seqlib_id", "seqtemplate_id", "Seqtemplates", "id");

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
