<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class Organisms extends \Phalcon\Mvc\Model
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
    public $taxonomy;

    /**
     *
     * @var integer
     */
    public $taxonomy_id;

    /**
     *
     * @var integer
     */
    public $sort_order;

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
            'taxonomy' => 'taxonomy',
            'taxonomy_id' => 'taxonomy_id',
            'sort_order' => 'sort_order',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->hasMany('taxonomy_id', 'Samples', 'taxonomy_id');
        
        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => Organisms::NOT_ACTIVE
            )
        ));
    }
}
