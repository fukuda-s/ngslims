<?php

class OligobarcodeSchemeAllows extends \Phalcon\Mvc\Model
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
    public $oligobarcode_scheme_id;

    /**
     *
     * @var integer
     */
    public $protocol_id;

    /**
     *
     * @var string
     */
    public $has_oligobarcodeB;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'oligobarcode_scheme_id' => 'oligobarcode_scheme_id',
            'protocol_id' => 'protocol_id',
            'has_oligobarcodeB' => 'has_oligobarcodeB'
        );
    }
}
