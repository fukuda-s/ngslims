<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class Steps extends \Phalcon\Mvc\Model
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
    public $step_phase_code;
     
    /**
     *
     * @var string
     */
    public $platform_code;
     
    /**
     *
     * @var string
     */
    public $nucleotide_type;
     
    /**
     *
     * @var integer
     */
    public $sort_order;
     
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
            'step_phase_code' => 'step_phase_code', 
            'platform_code' => 'platform_code', 
            'nucleotide_type' => 'nucleotide_type', 
            'sort_order' => 'sort_order', 
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->belongsTo('nucleotide_type', 'SampleTypes', 'nucleotide_type');
        $this->hasMany('platform_code', 'InstrumentTypes', 'platform_code');
        $this->hasOne('step_phase_code', 'StepPhases', 'step_phase_code');

        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => Steps::NOT_ACTIVE
            )
        ));
    }

}
