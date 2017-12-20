<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class InstrumentTypes extends \Phalcon\Mvc\Model
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
     * @var string
     */
    public $platform_code;

    /**
     *
     * @var integer
     */
    public $slots_per_run;

    /**
     *
     * @var string
     */
    public $slots_array_json;

    /**
     *
     * @var integer
     */
    public $sort_order;

    /**
     *
     * @var string
     */
    public $active;

    const ACTIVE = 'Y';

    const NOT_ACTIVE = 'N';

    public function getSlotStr($slot_num) {
        $slots_array = json_decode($this->slots_array_json);
        return $slots_array->$slot_num;
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'name' => 'name',
            'platform_code' => 'platform_code',
            'slots_per_run' => 'slots_per_run',
            'slots_array_json' => 'slots_array_json',
            'sort_order' => 'sort_order',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->belongsTo('platform_code', 'Platforms', 'platform_code');

        $this->hasMany('id', 'Instruments', 'instrument_type_id');
        $this->hasMany('id', 'StepInstrumentTypeSchemes', 'instrument_type_id');

        $this->hasManyToMany("id", "SeqRunTypeSchemes", "instrument_type_id", "seq_runmode_type_id", "SeqRunmodeTypes", "id");
        $this->hasManyToMany("id", "SeqRunTypeSchemes", "instrument_type_id", "seq_runread_type_id", "SeqRunreadTypes", "id");
        $this->hasManyToMany("id", "SeqRunTypeSchemes", "instrument_type_id", "seq_runcycle_type_id", "SeqRuncycleTypes", "id");

        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => InstrumentTypes::NOT_ACTIVE
            )
        ));
    }

}
