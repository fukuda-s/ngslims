<?php

class PipelineAnalyses extends \Phalcon\Mvc\Model
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
    public $pipeline_analysis_execution_id;

    /**
     *
     * @var integer
     */
    public $pipeline_reference_id;

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
     *
     * @var integer
     */
    public $seqlane_id;

    /**
     *
     * @var string
     */
    public $report_finished_at;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'pipeline_analysis_execution_id' => 'pipeline_analysis_execution_id',
            'pipeline_reference_id' => 'pipeline_reference_id',
            'sample_id' => 'sample_id',
            'seqlib_id' => 'seqlib_id',
            'seqlane_id' => 'seqlane_id',
            'report_finished_at' => 'report_finished_at'
        );
    }

}
