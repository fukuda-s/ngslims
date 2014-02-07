<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class SampleTypes extends \Phalcon\Mvc\Model
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
    public $nucleotide_type;

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

    public function columnMap()
    {
        return array(
            'id' => 'id',
            'name' => 'name',
            'nucleotide_type' => 'nucleotide_type',
            'sort_order' => 'sort_order',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->hasMany('nucleotide_type', 'Steps', 'nucleotide_type');

        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => SampleTypes::NOT_ACTIVE
            )
        ));
    }
}
