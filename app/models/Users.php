<?php
use Phalcon\Mvc\Model\Validator\Email as EmailValidator;
use Phalcon\Mvc\Model\Validator\Uniqueness as UniquenessValidator;
use Phalcon\Mvc\Model\Behavior\SoftDelete;

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

    public function validation()
    {
        $this->validate(new EmailValidator(array(
            'field' => 'email'
        )));
        $this->validate(new UniquenessValidator(array(
            'field' => 'email',
            'message' => 'Sorry, The email was registered by another user'
        )));
        $this->validate(new UniquenessValidator(array(
            'field' => 'username',
            'message' => 'Sorry, That username is already taken'
        )));
        if ($this->validationHasFailed() == true) {
            return false;
        }
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

        $this->hasManyToMany('id', 'Projects', 'user_id', 'id', 'Samples', 'project_id', array(
            'alias' => 'UserSamples'
        ));
        $this->hasManyToMany('id', 'Projects', 'pi_user_id', 'id', 'Samples', 'project_id', array(
            'alias' => 'PiSamples'
        ));

        $this->addBehavior(new SoftDelete(
            [
                'field' => 'active',
                'value' => Users::NOT_ACTIVE
            ]
        ));
    }
}
