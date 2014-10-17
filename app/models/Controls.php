<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class Controls extends \Phalcon\Mvc\Model
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
     * @var string
     */
    public $active;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'name' => 'name',
            'platform_code' => 'platform_code',
            'active' => 'active'
        );
    }

    const ACTIVE = 'Y';

    const NOT_ACTIVE = 'N';

    public function initialize()
    {
        $this->addBehavior(new SoftDelete(
            [
                'field' => 'active',
                'value' => Users::NOT_ACTIVE
            ]
        ));
    }

}
