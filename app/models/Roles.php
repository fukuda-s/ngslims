<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class Roles extends \Phalcon\Mvc\Model
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
    public $role_code;

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
            'role_code' => 'role_code',
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
