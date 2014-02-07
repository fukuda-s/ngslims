<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class Platforms extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var string
     */
    public $platform_code;

    /**
     *
     * @var string
     */
    public $description;

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
            'platform_code' => 'platform_code',
            'description' => 'description',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => Platforms::NOT_ACTIVE
            )
        ));
    }

}
