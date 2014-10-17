<?php


class RoleUsers extends \Phalcon\Mvc\Model
{



    /**
     *
     * @var integer
     */
    public $user_id;

    /**
     *
     * @var string
     */
    public $role_code;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'user_id' => 'user_id',
            'role_code' => 'role_code'
        );
    }

    public function initialize()
    {
        $this->belongsTo('user_id', 'Users', 'id');
        $this->belongsTo('role_code', 'Roles', 'role_code');
    }
}
