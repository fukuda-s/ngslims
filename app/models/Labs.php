<?php


use Phalcon\Validation;
use Phalcon\Validation\Validator\Email as Email;
use Phalcon\Validation\Validator\Uniqueness as Uniqueness;
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

    public function validator()
    {
        $validator = new Validation();

        $validator->add(
            "email",
            new Email(
                [
                    "message" => "The e-mail is not valid",
                ]
            )
        );

        return $this->validate($validator);
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
        $this->hasMany('id', 'LabUsers', 'lab_id');
        $this->hasManyToMany('id', 'LabUsers', 'lab_id', 'user_id', 'Users', 'id', array(
            'alias' => 'LabUsersUsers'
        ));

        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => Labs::NOT_ACTIVE
            )
        ));
    }

}
