<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class SampleLocations extends \Phalcon\Mvc\Model
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
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->hasMany('id', 'Samples', 'sample_location_id');
        
        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => Instruments::NOT_ACTIVE
            )
        ));
    }

}
