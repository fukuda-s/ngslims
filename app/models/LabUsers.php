<?php


class LabUsers extends \Phalcon\Mvc\Model
{

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
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'lab_id' => 'lab_id',
            'user_id' => 'user_id'
        );
    }

    public function initialize()
    {
        $this->belongsTo('lab_id', 'Labs', 'id', array('alias' => 'Labs'));
        $this->belongsTo('user_id', 'Users', 'id', array('alias' => 'Users'));
    }
}
