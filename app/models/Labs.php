<?php


use Phalcon\Mvc\Model\Validator\Email as Email;
use Phalcon\Mvc\Model\Behavior\SoftDelete;

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

    const ACTIVE = 'Y';

    const NOT_ACTIVE = 'N';

    public function validation()
    {
        $this->validate(new Email(array(
            "field" => "email",
            "required" => true
        )));
        if ($this->validationHasFailed() == true) {
            return false;
        }
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'name' => 'name',
            'department' => 'department',
            'zipcode' => 'zipcode',
            'address1' => 'address1',
            'address2' => 'address2',
            'phone' => 'phone',
            'fax' => 'fax',
            'email' => 'email',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => Labs::NOT_ACTIVE
            )
        ));
    }

}
