<?php


class Labs extends \Phalcon\Mvc\Model
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
    public $department;
     
    /**
     *
     * @var string
     */
    public $zipcode;
     
    /**
     *
     * @var string
     */
    public $address1;
     
    /**
     *
     * @var string
     */
    public $address2;
     
    /**
     *
     * @var string
     */
    public $phone;
     
    /**
     *
     * @var string
     */
    public $fax;
     
    /**
     *
     * @var string
     */
    public $email;
     
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
    public function setDepartment($department)
    {
        $this->department = $department;
        return $this;
    }
    public function setZipcode($zipcode)
    {
        $this->zipcode = $zipcode;
        return $this;
    }
    public function setAddress1($address1)
    {
        $this->address1 = $address1;
        return $this;
    }
    public function setAddress2($address2)
    {
        $this->address2 = $address2;
        return $this;
    }
    public function setPhone($phone)
    {
        $this->phone = $phone;
        return $this;
    }
    public function setFax($fax)
    {
        $this->fax = $fax;
        return $this;
    }
    public function setEmail($email)
    {
        $this->email = $email;
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
    public function getDepartment()
    {
        return $this->department;
    }
    public function getZipcode()
    {
        return $this->zipcode;
    }
    public function getAddress1()
    {
        return $this->address1;
    }
    public function getAddress2()
    {
        return $this->address2;
    }
    public function getPhone()
    {
        return $this->phone;
    }
    public function getFax()
    {
        return $this->fax;
    }
    public function getEmail()
    {
        return $this->email;
    }
    public function getActive()
    {
        return $this->active;
    }
    public function validation()
    {

        $this->validate(
            new Email(
                array(
                    "field"    => "email",
                    "required" => true,
                )
            )
        );
        if ($this->validationHasFailed() == true) {
            return false;
        }
    }

}
