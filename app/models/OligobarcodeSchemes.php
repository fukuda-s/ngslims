<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class OligobarcodeSchemes extends \Phalcon\Mvc\Model
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
    public $description;

    /**
     *
     * @var string
     */
    public $is_oligobarcodeB;

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
            'description' => 'description',
            'is_oligobarcodeB' => 'is_oligobarcodeB',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->hasMany('id', 'Oligobarcodes', 'oligobarcode_scheme_id');
        
        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => OligobarcodeSchemes::NOT_ACTIVE
            )
        ));
    }

}
