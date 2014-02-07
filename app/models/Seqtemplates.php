<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;

class Seqtemplates extends \Phalcon\Mvc\Model
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
     * @var double
     */
    public $init_conc;

    /**
     *
     * @var double
     */
    public $init_vol;

    /**
     *
     * @var double
     */
    public $target_conc;

    /**
     *
     * @var double
     */
    public $target_dw_vol;

    /**
     *
     * @var double
     */
    public $target_vol;

    /**
     *
     * @var double
     */
    public $final_conc;

    /**
     *
     * @var double
     */
    public $final_dw_vol;

    /**
     *
     * @var double
     */
    public $final_vol;

    /**
     *
     * @var string
     */
    public $started_at;

    /**
     *
     * @var string
     */
    public $finished_at;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'name' => 'name',
            'init_conc' => 'init_conc',
            'init_vol' => 'init_vol',
            'target_conc' => 'target_conc',
            'target_dw_vol' => 'target_dw_vol',
            'target_vol' => 'target_vol',
            'final_conc' => 'final_conc',
            'final_dw_vol' => 'final_dw_vol',
            'final_vol' => 'final_vol',
            'started_at' => 'started_at',
            'finished_at' => 'finished_at',
            'created_at' => 'created_at'
        );
    }

    public function initialize()
    {
        $this->addBehavior(new Timestampable(
            array(
                'beforeValidationOnCreate' => array(
                    'field' => 'created_at',
                    'format' => 'Y-m-d H:i:s'
                )
            )
        ));
    }

}
