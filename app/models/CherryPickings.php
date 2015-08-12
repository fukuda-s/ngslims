<?php
use Phalcon\Mvc\Model\Behavior\Timestampable;
use Phalcon\Mvc\Model\Behavior\SoftDelete;

class CherryPickings extends \Phalcon\Mvc\Model
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
     * @var integer
     */
    public $user_id;

    /**
     *
     * @var string
     */
    public $created_at;

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
            'user_id' => 'user_id', 
            'created_at' => 'created_at', 
            'active' => 'active'
        );
    }

    const ACTIVE = 'Y';

    const NOT_ACTIVE = 'N';

    public function initialize()
    {

        $this->belongsTo('user_id', 'Users', 'id', array(
            "alias" => "Users"
        ));
        $this->hasMany('id', 'CherryPickingSchemes', 'cherry_picking_id');

        $this->addBehavior(new Timestampable(
            array(
                'beforeValidationOnCreate' => array(
                    'field' => 'created_at',
                    'format' => 'Y-m-d H:i:s'
                )
            )
        ));

        $this->addBehavior(new SoftDelete(
            [
                'field' => 'active',
                'value' => Users::NOT_ACTIVE
            ]
        ));
    }

}
