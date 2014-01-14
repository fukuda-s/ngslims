<?php


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
         public function setId($id)
    {
        $this->id = $id;
        return $this;
    }
    public function setName($name)
    {
        $this->name = $name;
        return $this;
    }
    public function setBarcodeSeq($barcode_seq)
    {
        $this->barcode_seq = $barcode_seq;
        return $this;
    }
    public function setOligobarcodeSchemeId($oligobarcode_scheme_id)
    {
        $this->oligobarcode_scheme_id = $oligobarcode_scheme_id;
        return $this;
    }
    public function setSortOrder($sort_order)
    {
        $this->sort_order = $sort_order;
        return $this;
    }
    public function setActive($active)
    {
        $this->active = $active;
        return $this;
    }
    public function getId()
    {
        return $this->id;
    }
    public function getName()
    {
        return $this->name;
    }
    public function getBarcodeSeq()
    {
        return $this->barcode_seq;
    }
    public function getOligobarcodeSchemeId()
    {
        return $this->oligobarcode_scheme_id;
    }
    public function getSortOrder()
    {
        return $this->sort_order;
    }
    public function getActive()
    {
        return $this->active;
    }

}
