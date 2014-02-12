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
    public $sort_order;

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
            'name' => 'name',
            'platform_code' => 'platform_code',
            'sort_order' => 'sort_order',
            'active' => 'active'
        );
    }

    public function initialize()
    {
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
