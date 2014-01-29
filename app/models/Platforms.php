<?php


class Platforms extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var string
     */
    public $platform_code;

    /**
     *
     * @var string
     */
    public $description;

    /**
     *
     * @var string
     */
    public $active;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'platform_code' => 'platform_code',
            'description' => 'description',
            'active' => 'active'
        );
    }

}
