<?php

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
}
