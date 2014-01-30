<?php




class SeqRuncycleTypeAllows extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var integer
     */
    public $id;
     
    /**
     *
     * @var integer
     */
    public $seq_runcycle_type_id;
     
    /**
     *
     * @var integer
     */
    public $instrument_type_id;
     
    /**
     *
     * @var integer
     */
    public $seq_runmode_type_id;
     
    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id', 
            'seq_runcycle_type_id' => 'seq_runcycle_type_id', 
            'instrument_type_id' => 'instrument_type_id', 
            'seq_runmode_type_id' => 'seq_runmode_type_id'
        );
    }

}
