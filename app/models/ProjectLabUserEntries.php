<?php

class ProjectLabUserEntries extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var integer
     */
    public $project_id;

    /**
     *
     * @var integer
     */
    public $lab_id;

    /**
     *
     * @var integer
     */
    public $user_id;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->belongsTo('lab_id', 'Labs', 'id', array('alias' => 'Labs'));
        $this->belongsTo('project_id', 'Projects', 'id', array('alias' => 'Projects'));
        $this->belongsTo('user_id', 'Users', 'id', array('alias' => 'Users'));
    }

    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'project_lab_user_entries';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProjectLabUserEntries[]
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return ProjectLabUserEntries
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
