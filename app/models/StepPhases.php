<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class StepPhases extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var string
     */
    public $step_phase_code;

    /**
     *
     * @var string
     */
    public $description;

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
            'step_phase_code' => 'step_phase_code',
            'description' => 'description',
            'sort_order' => 'sort_order',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => StepPhases::NOT_ACTIVE
            )
        ));
    }
}
