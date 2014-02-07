<?php

class SeqtemplateAssocs extends \Phalcon\Mvc\Model
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
    public $seqtemplate_id;

    /**
     *
     * @var integer
     */
    public $seqlib_id;

    /**
     *
     * @var double
     */
    public $assoc_factor;

    /**
     *
     * @var double
     */
    public $assoc_vol;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'seqtemplate_id' => 'seqtemplate_id',
            'seqlib_id' => 'seqlib_id',
            'assoc_factor' => 'assoc_factor',
            'assoc_vol' => 'assoc_vol'
        );
    }

    public function initialize()
    {
        $this->hasMany("id", "Seqlanes", "seqtemplate_id");
        
        $this->addBehavior(new Timestampable(
            array(
                'beforeCreate' => array(
                    'field' => 'created_at',
                    'format' => 'Y-m-d'
                )
            )
        ));
    }
}
