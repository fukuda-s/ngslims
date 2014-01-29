<?php


class StepEntries extends \Phalcon\Mvc\Model
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
    public $sample_id;

    /**
     *
     * @var integer
     */
    public $step_id;

    /**
     *
     * @var string
     */
    public $start_at;

    /**
     *
     * @var string
     */
    public $finish_at;

    /**
     *
     * @var string
     */
    public $note;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'sample_id' => 'sample_id',
            'step_id' => 'step_id',
            'start_at' => 'start_at',
            'finish_at' => 'finish_at',
            'note' => 'note'
        );
    }

}
