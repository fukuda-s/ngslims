<?php


class SamplePropertyTypes extends \Phalcon\Mvc\Model
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
    public $mo_term_name;
     
    /**
     *
     * @var string
     */
    public $mo_id;
     
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
    public function setMoTermName($mo_term_name)
    {
        $this->mo_term_name = $mo_term_name;
        return $this;
    }
    public function setMoId($mo_id)
    {
        $this->mo_id = $mo_id;
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
    public function getMoTermName()
    {
        return $this->mo_term_name;
    }
    public function getMoId()
    {
        return $this->mo_id;
    }
    public function getActive()
    {
        return $this->active;
    }

}
