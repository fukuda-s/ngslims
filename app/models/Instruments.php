<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class Instruments extends \Phalcon\Mvc\Model
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
    public $instrument_number;

    /**
     *
     * @var string
     */
    public $nickname;

    /**
     *
     * @var integer
     */
    public $instrument_type_id;

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
            'instrument_number' => 'instrument_number',
            'nickname' => 'nickname',
            'instrument_type_id' => 'instrument_type_id',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => Instruments::NOT_ACTIVE
            )
        ));
    }
}
