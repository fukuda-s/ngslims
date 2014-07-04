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
    public $target_conc;

    /**
     *
     * @var double
     */
    public $target_vol;

    /**
     *
     * @var double
     */
    public $target_dw_vol;

    /**
     *
     * @var double
     */
    public $initial_conc;

    /**
     *
     * @var double
     */
    public $initial_vol;

    /**
     *
     * @var double
     */
    public $final_conc;

    /**
     *
     * @var double
     */
    public $final_vol;

    /**
     *
     * @var double
     */
    public $final_dw_vol;

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
            'target_conc' => 'target_conc',
            'target_vol' => 'target_vol',
            'target_dw_vol' => 'target_dw_vol',
            'initial_conc' => 'initial_conc',
            'initial_vol' => 'initial_vol',
            'final_conc' => 'final_conc',
            'final_vol' => 'final_vol',
            'final_dw_vol' => 'final_dw_vol',
            'started_at' => 'started_at',
            'finished_at' => 'finished_at',
            'created_at' => 'created_at'
        );
    }

    public function initialize()
    {
        $this->hasMany('id', 'SeqtemplateAssocs', 'seqtemplate_id');
        $this->hasMany('id', 'StepEntries', 'seqtemplate_id');

        $this->hasManyToMany('id', 'SeqtemplateAssocs', 'seqtemplate_id', 'seqlib_id', 'Seqlibs', 'id');


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
