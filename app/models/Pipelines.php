<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;
use Phalcon\Mvc\Model\Behavior\SoftDelete;

class Pipelines extends \Phalcon\Mvc\Model
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
    public $pipeline_type_id;

    /**
     *
     * @var string
     */
    public $version;

    /**
     *
     * @var string
     */
    public $developer;

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
            'pipeline_type_id' => 'pipeline_type_id', 
            'version' => 'version', 
            'developer' => 'developer', 
            'created_at' => 'created_at', 
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->addBehavior(new Timestampable(
            array(
                'beforeValidationOnCreate' => array(
                    'field' => 'created_at',
                    'format' => 'Y-m-d H:i:s'
                )
            )
        ));

        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => SampleTypes::NOT_ACTIVE
            )
        ));
    }

}
