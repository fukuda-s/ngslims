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
    public $seq_runmode_type_id;

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
    public $run_started_date;

    /**
     *
     * @var string
     */
    public $run_finished_date;

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
            'seq_runmode_type_id' => 'seq_runmode_type_id',
            'seq_run_type_scheme_id' => 'seq_run_type_scheme_id',
            'run_number' => 'run_number',
            'instrument_id' => 'instrument_id',
            'side' => 'side',
            'run_started_date' => 'run_started_date',
            'run_finished_date' => 'run_finished_date',
            'dirname' => 'dirname',
            'created_at' => 'created_at',
            'notes' => 'notes'
        );
    }

    public function initialize()
    {
        $this->belongsTo('instrument_id', 'Instruments', 'id');

        $this->hasMany('id', 'Seqlanes', 'flowcell_id');
        $this->hasMany('id', 'StepEntries', 'flowcell_id');
        $this->hasMany('id', 'SeqDemultiplexResults', 'flowcell_id');

        $this->hasOne('seq_runmode_type_id', 'SeqRunmodeTypes', 'id');

        $this->hasManyToMany('id', 'Seqlanes', 'flowcell_id', 'seqtemplate_id', 'Seqtemplates', 'id');

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
