<?php

class Projects extends \Phalcon\Mvc\Model
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
    public $lab_id;

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
     * @var integer
     */
    public $pi_user_id;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     *
     * @var string
     */
    public $description;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'lab_id' => 'lab_id',
            'name' => 'name',
            'user_id' => 'user_id',
            'pi_user_id' => 'pi_user_id',
            'created_at' => 'created_at',
            'description' => 'description'
        );
    }

    public function initialize()
    {
        $this->belongsTo('lab_id', 'Labs', 'id');
        $this->belongsTo('user_id', 'Users', 'id', array(
            "alias" => "Users"
        ));
        $this->belongsTo('pi_user_id', 'Users', 'id', array(
            "alias" => "PIs"
        ));

        $this->hasMany('id', 'Samples', 'project_id');

        $this->addBehavior(new Timestampable(
            array(
                'beforeCreate' => array(
                    'field' => 'created_at',
                    'format' => 'Y-m-d'
                )
            )
        ));
    }
}
