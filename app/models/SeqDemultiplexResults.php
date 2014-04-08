<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;

class SeqDemultiplexResults extends \Phalcon\Mvc\Model
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
    public $seqlib_id;

    /**
     *
     * @var integer
     */
    public $seqlane_id;

    /**
     *
     * @var integer
     */
    public $flowcell_id;

    /**
     *
     * @var string
     */
    public $is_undetermined;

    /**
     *
     * @var integer
     */
    public $reads_total;

    /**
     *
     * @var integer
     */
    public $reads_passedfilter;

    /**
     *
     * @var string
     */
    public $software_version;

    /**
     *
     * @var string
     */
    public $create_at;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'seqlib_id' => 'seqlib_id',
            'seqlane_id' => 'seqlane_id',
            'flowcell_id' => 'flowcell_id',
            'is_undetermined' => 'is_undetermined',
            'reads_total' => 'reads_total',
            'reads_passedfilter' => 'reads_passedfilter',
            'software_version' => 'software_version',
            'create_at' => 'create_at'
        );
    }

    public function initialize()
    {
        $this->belongsTo('seqlib_id', 'Seqlibs', 'id');
        $this->belongsTo('seqlane_id', 'Seqlanes', 'id');
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
