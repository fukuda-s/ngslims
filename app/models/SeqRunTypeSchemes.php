<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class SeqRunTypeSchemes extends \Phalcon\Mvc\Model
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
    public $instrument_type_id;
     
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
     * @var string
     */
    public $active;

    const ACTIVE = 'Y';

    const NOT_ACTIVE = 'N';

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'instrument_type_id' => 'instrument_type_id', 
            'seq_runmode_type_id' => 'seq_runmode_type_id', 
            'seq_runread_type_id' => 'seq_runread_type_id', 
            'seq_runcycle_type_id' => 'seq_runcycle_type_id', 
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->belongsTo("instrument_type_id", "InstrumentTypes", "id");
        $this->belongsTo("seq_runmode_type_id", "SeqRunmodeTypes", "id");
        $this->belongsTo("seq_runread_type_id", "SeqRunreadTypes", "id");
        $this->belongsTo("seq_runcycle_type_id", "SeqRuncycleTypes", "id");

        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => SeqRunTypeSchemes::NOT_ACTIVE
            )
        ));
    }

}
