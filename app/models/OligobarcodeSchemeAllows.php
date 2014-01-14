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
    public $seqlib_protocol_id;
     
    /**
     *
     * @var string
     */
    public $has_oligobarcodeB;
         public function setId($id)
    {
        $this->id = $id;
        return $this;
    }
    public function setOligobarcodeSchemeId($oligobarcode_scheme_id)
    {
        $this->oligobarcode_scheme_id = $oligobarcode_scheme_id;
        return $this;
    }
    public function setSeqlibProtocolId($seqlib_protocol_id)
    {
        $this->seqlib_protocol_id = $seqlib_protocol_id;
        return $this;
    }
    public function setHasOligobarcodeB($has_oligobarcodeB)
    {
        $this->has_oligobarcodeB = $has_oligobarcodeB;
        return $this;
    }
    public function getId()
    {
        return $this->id;
    }
    public function getOligobarcodeSchemeId()
    {
        return $this->oligobarcode_scheme_id;
    }
    public function getSeqlibProtocolId()
    {
        return $this->seqlib_protocol_id;
    }
    public function getHasOligobarcodeB()
    {
        return $this->has_oligobarcodeB;
    }

}
