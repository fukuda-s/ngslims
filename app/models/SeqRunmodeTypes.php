<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class SeqRunmodeTypes extends \Phalcon\Mvc\Model
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
    public $lane_per_flowcell;

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
            'lane_per_flowcell' => 'lane_per_flowcell',
            'sort_order' => 'sort_order',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->hasMany('id', 'SeqRunTypeSchemes', 'seq_runmode_type_id');
        
        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => SeqRunmodeTypes::NOT_ACTIVE
            )
        ));
    }
}
