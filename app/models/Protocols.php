<?php

use Phalcon\Mvc\Model\Behavior\Timestampable,
    Phalcon\Mvc\Model\Behavior\SoftDelete;

class Protocols extends \Phalcon\Mvc\Model
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
    public $description;

    /**
     *
     * @var integer
     */
    public $step_id;

    /**
     *
     * @var integer
     */
    public $min_multiplex_number;

    /**
     *
     * @var integer
     */
    public $max_multiplex_number;

    /**
     *
     * @var string
     */
    public $next_step_phase_code;

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

    const ACTIVE = 'Y';

    const NOT_ACTIVE = 'N';

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'name' => 'name',
            'description' => 'description',
            'step_id' => 'step_id',
            'min_multiplex_number' => 'min_multiplex_number',
            'max_multiplex_number' => 'max_multiplex_number',
            'next_step_phase_code' => 'next_step_phase_code',
            'created_at' => 'created_at',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->hasOne('step_id', 'Steps', 'id');

        $this->hasMany('id', 'Seqlibs', 'protocol_id');
        $this->hasMany('id', 'OligobarcodeSchemeAllows', 'protocol_id');

        $this->addBehavior(new Timestampable(
            array(
                'beforeValidationOnCreate' => array(
                    'field' => 'created_at',
                    'format' => 'Y-m-d H:i:s'
                )
            )
        ));

        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => Protocols::NOT_ACTIVE
            )
        ));
    }
}
