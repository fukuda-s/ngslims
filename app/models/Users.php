<?php
use Phalcon\Validation;
use Phalcon\Validation\Validator\Email as Email;
use Phalcon\Validation\Validator\Uniqueness as Uniqueness;
use Phalcon\Mvc\Model\Behavior\SoftDelete;
use Phalcon\Mvc\Model\Behavior\Timestampable;
use Phalcon\Db\RawValue;

class Users extends \Phalcon\Mvc\Model
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
    public $username;

    /**
     *
     * @var string
     */
    public $password;

    /**
     *
     * @var string
     */
    public $firstname;

    /**
     *
     * @var string
     */
    public $lastname;

    /**
     *
     * @var string
     */
    public $email;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     *
     * @var string
     */
    public $active;

    public function getFullname()
    {
        if (!empty($this->firstname) && !empty($this->lastname)) {
            return $this->lastname . ', ' . $this->firstname;
        } elseif (!empty($this->firstname)) {
            return $this->firstname;
        } elseif (!empty($this->lastname)) {
            return $this->lastname;
        } else {
            return 'Undefined';
        }
    }

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

        $validator->add(
            "username",
            new Uniqueness(
                [
                    "message" => "The username must be unique"
                ]
            )
        );

        $validator->add(
            "email",
            new Uniqueness(
                [
                    'message' => 'Sorry, The email was registered by another user'
                ]
            )
        );


        return $this->validate($validator);
    }

    public function columnMap()
    {
        return array(
            'id' => 'id',
            'username' => 'username',
            'password' => 'password',
            'firstname' => 'firstname',
            'lastname' => 'lastname',
            'email' => 'email',
            'created_at' => 'created_at',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->hasMany('id', 'Projects', 'user_id', array(
            'alias' => 'UserProjects'
        ));
        $this->hasMany('id', 'Projects', 'pi_user_id', array(
            'alias' => 'PiProjects'
        ));

        $this->hasMany('id', 'Requests', 'user_id');
        $this->hasMany('id', 'LabUsers', 'user_id');
        $this->hasMany('id', 'ProjectUsers', 'user_id');

        $this->hasManyToMany('id', 'Projects', 'user_id', 'id', 'Samples', 'project_id', array(
            'alias' => 'UserSamples'
        ));
        $this->hasManyToMany('id', 'Projects', 'pi_user_id', 'id', 'Samples', 'project_id', array(
            'alias' => 'PiSamples'
        ));
        $this->hasManyToMany('id', 'LabUsers', 'user_id', 'lab_id', 'Labs', 'id', array(
            'alias' => 'UserLabs'
        ));

        $this->addBehavior(new SoftDelete(
            [
                'field' => 'active',
                'value' => Users::NOT_ACTIVE
            ]
        ));

        $this->addBehavior(new Timestampable(
            array(
                'beforeValidationOnCreate' => array(
                    'field' => 'created_at',
                    'format' => 'Y-m-d H:i:s'
                )
            )
        ));
    }

    public function beforeValidationOnCreate()
    {
        if (!$this->active) {
            $this->active = new RawValue('default');
        }
        if (!$this->created_at) {
            $this->created_at = new RawValue('default');
        }
    }
}
