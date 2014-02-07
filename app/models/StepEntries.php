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
    public $started_at;

    /**
     *
     * @var string
     */
    public $finished_at;

    /**
     *
     * @var string
     */
    public $created_at;

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
            'started_at' => 'started_at',
            'finished_at' => 'finished_at',
            'created_at' => 'created_at',
            'note' => 'note'
        );
    }

}
