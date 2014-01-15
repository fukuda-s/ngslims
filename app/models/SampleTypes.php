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
    public function setNucleotideType($nucleotide_type)
    {
        $this->nucleotide_type = $nucleotide_type;
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
    public function getNucleotideType()
    {
        return $this->nucleotide_type;
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
