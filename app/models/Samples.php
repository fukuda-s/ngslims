<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;

class Samples extends \Phalcon\Mvc\Model
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
     * @var integer
     */
    public $request_id;

    /**
     *
     * @var integer
     */
    public $project_id;

    /**
     *
     * @var integer
     */
    public $sample_type_id;

    /**
     *
     * @var integer
     */
    public $organism_id;

    /**
     *
     * @var double
     */
    public $qual_concentration;

    /**
     *
     * @var double
     */
    public $qual_volume;

    /**
     *
     * @var double
     */
    public $qual_amount;

    /**
     *
     * @var double
     */
    public $qual_RIN;

    /**
     *
     * @var double
     */
    public $qual_od260280;

    /**
     *
     * @var double
     */
    public $qual_od260230;

    /**
     *
     * @var double
     */
    public $qual_nanodrop_conc;

    /**
     *
     * @var integer
     */
    public $qual_fragment_size;

    /**
     *
     * @var string
     */
    public $qual_date;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     *
     * @var string
     */
    public $description;

    public function getSource()
    {
        return 'samples';
    }

    public function columnMap()
    {
        return array(
            'id' => 'id',
            'name' => 'name',
            'request_id' => 'request_id',
            'project_id' => 'project_id',
            'sample_type_id' => 'sample_type_id',
            'organism_id' => 'organism_id',
            'qual_concentration' => 'qual_concentration',
            'qual_volume' => 'qual_volume',
            'qual_amount' => 'qual_amount',
            'qual_RIN' => 'qual_RIN',
            'qual_od260280' => 'qual_od260280',
            'qual_od260230' => 'qual_od260230',
            'qual_nanodrop_conc' => 'qual_nanodrop_conc',
            'qual_fragment_size' => 'qual_fragment_size',
            'qual_date' => 'qual_date',
            'created_at' => 'created_at',
            'description' => 'description'
        );
    }

    public function initialize()
    {
        $this->hasOne('organism_id', 'Organisms', 'id');
        $this->hasOne('project_id', 'Projects', 'id');
        $this->hasOne('request_id', 'Requests', 'id');
        $this->hasOne('sample_type_id', 'SampleTypes', 'id');

        $this->hasMany('id', 'SeqLibs', 'sample_id');
        $this->hasMany('id', 'StepEntries', 'sample_id');

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
