<?php




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
     * @var string
     */
    public $create_at;
     
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
            'id' => 'id', 
            'name' => 'name', 
            'description' => 'description', 
            'step_id' => 'step_id', 
            'create_at' => 'create_at', 
            'active' => 'active'
        );
    }

}
