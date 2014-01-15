<?php


class InstrumentTypes extends \Phalcon\Mvc\Model
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
    public $sort_order;
     
    /**
     *
     * @var string
     */
    public $active;
     
    /**
     * Independent Column Mapping.
     */
    public function columnMap() {
        return array(
            'id' => 'id', 
            'name' => 'name', 
            'sort_order' => 'sort_order', 
            'active' => 'active'
        );
    }

}
