<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class Oligobarcodes extends \Phalcon\Mvc\Model
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
    public $barcode_seq;

    /**
     *
     * @var integer
     */
    public $oligobarcode_scheme_id;

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
            'barcode_seq' => 'barcode_seq',
            'oligobarcode_scheme_id' => 'oligobarcode_scheme_id',
            'sort_order' => 'sort_order',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => Oligobarcodes::NOT_ACTIVE
            )
        ));
    }
}
