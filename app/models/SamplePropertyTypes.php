<?php

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class SamplePropertyTypes extends \Phalcon\Mvc\Model
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
    public $mo_term_name;

    /**
     *
     * @var string
     */
    public $mo_id;

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
            'mo_term_name' => 'mo_term_name',
            'mo_id' => 'mo_id',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => SamplePropertyTypes::NOT_ACTIVE
            )
        ));
    }
}
