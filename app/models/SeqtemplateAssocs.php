<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;

class SeqtemplateAssocs extends \Phalcon\Mvc\Model
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
    public $seqtemplate_id;

    /**
     *
     * @var integer
     */
    public $seqlib_id;

    /**
     *
     * @var double
     */
    public $conc_factor;

    /**
     *
     * @var double
     */
    public $input_vol;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'seqtemplate_id' => 'seqtemplate_id',
            'seqlib_id' => 'seqlib_id',
            'conc_factor' => 'conc_factor',
            'input_vol' => 'input_vol'
        );
    }

    public function initialize()
    {
        $this->belongsTo("seqtemplate_id", "Seqlanes", "seqtemplate_id");
        $this->belongsTo("seqtemplate_id", "Seqtemplates", "id");
        $this->belongsTo("seqlib_id", "Seqlibs", "id");

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
