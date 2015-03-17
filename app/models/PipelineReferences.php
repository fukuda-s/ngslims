<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;
use Phalcon\Mvc\Model\Behavior\SoftDelete;

class PipelineReferences extends \Phalcon\Mvc\Model
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
    public $organism_id;

    /**
     *
     * @var string
     */
    public $released_at;

    /**
     *
     * @var string
     */
    public $data_path;

    /**
     *
     * @var string
     */
    public $description;

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
            'organism_id' => 'organism_id',
            'released_at' => 'released_at',
            'data_path' => 'data_path',
            'description' => 'description',
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
