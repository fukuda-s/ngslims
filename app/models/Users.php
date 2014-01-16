<?php

class Users extends \Phalcon\Mvc\Model {

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
	public $name;

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

	public function validation() {
		$this->validate(new Email(array (
				"field" => "email",
				"required" => true
		)));
		if ( $this->validationHasFailed() == true ) {
			return false;
		}
	}

	public function getSource() {
		return 'users';
	}

	public function columnMap() {
		return array (
				'id' => 'id',
				'username' => 'username',
				'password' => 'password',
				'name' => 'name',
				'email' => 'email',
				'created_at' => 'created_at',
				'active' => 'active'
		);
	}

	public function initialize() {
		$this->hasMany('id', 'Projects', 'user_id');
		$this->hasMany('id', 'Requests', 'user_id');
		$this->hasMany('id', 'Samples', 'user_id');
	}
}
