<?php


class Seqtemplates extends \Phalcon\Mvc\Model
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
     * @var double
     */
    public $init_conc;
     
    /**
     *
     * @var double
     */
    public $init_vol;
     
    /**
     *
     * @var double
     */
    public $target_conc;
     
    /**
     *
     * @var double
     */
    public $target_dw_vol;
     
    /**
     *
     * @var double
     */
    public $target_vol;
     
    /**
     *
     * @var double
     */
    public $final_conc;
     
    /**
     *
     * @var double
     */
    public $final_dw_vol;
     
    /**
     *
     * @var double
     */
    public $final_vol;
     
    /**
     *
     * @var string
     */
    public $create_at;
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
    public function setInitConc($init_conc)
    {
        $this->init_conc = $init_conc;
        return $this;
    }
    public function setInitVol($init_vol)
    {
        $this->init_vol = $init_vol;
        return $this;
    }
    public function setTargetConc($target_conc)
    {
        $this->target_conc = $target_conc;
        return $this;
    }
    public function setTargetDwVol($target_dw_vol)
    {
        $this->target_dw_vol = $target_dw_vol;
        return $this;
    }
    public function setTargetVol($target_vol)
    {
        $this->target_vol = $target_vol;
        return $this;
    }
    public function setFinalConc($final_conc)
    {
        $this->final_conc = $final_conc;
        return $this;
    }
    public function setFinalDwVol($final_dw_vol)
    {
        $this->final_dw_vol = $final_dw_vol;
        return $this;
    }
    public function setFinalVol($final_vol)
    {
        $this->final_vol = $final_vol;
        return $this;
    }
    public function setCreateAt($create_at)
    {
        $this->create_at = $create_at;
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
    public function getInitConc()
    {
        return $this->init_conc;
    }
    public function getInitVol()
    {
        return $this->init_vol;
    }
    public function getTargetConc()
    {
        return $this->target_conc;
    }
    public function getTargetDwVol()
    {
        return $this->target_dw_vol;
    }
    public function getTargetVol()
    {
        return $this->target_vol;
    }
    public function getFinalConc()
    {
        return $this->final_conc;
    }
    public function getFinalDwVol()
    {
        return $this->final_dw_vol;
    }
    public function getFinalVol()
    {
        return $this->final_vol;
    }
    public function getCreateAt()
    {
        return $this->create_at;
    }

}
