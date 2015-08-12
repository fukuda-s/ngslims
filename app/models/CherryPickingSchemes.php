<?php

class CherryPickingSchemes extends \Phalcon\Mvc\Model
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
    public $cherry_picking_id;

    /**
     *
     * @var integer
     */
    public $sample_id;

    /**
     *
     * @var integer
     */
    public $seqlib_id;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'cherry_picking_id' => 'cherry_picking_id',
            'sample_id' => 'sample_id',
            'seqlib_id' => 'seqlib_id'
        );
    }

    public function initialize()
    {
        $this->belongsTo("cherry_picking_id", "CherryPickings", "id");
        $this->belongsTo("sample_id", "Samples", "id");
        $this->belongsTo("seqlib_id", "Seqlibs", "id");
    }
}
