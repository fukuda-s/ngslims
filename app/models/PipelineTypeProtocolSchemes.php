<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;
use Phalcon\Mvc\Model\Behavior\SoftDelete;

class PipelineTypeProtocolSchemes extends \Phalcon\Mvc\Model
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
    public $pipeline_type_id;

    /**
     *
     * @var integer
     */
    public $protocol_id;

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
            'pipeline_type_id' => 'pipeline_type_id',
            'protocol_id' => 'protocol_id',
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
