<?php

use Phalcon\Mvc\Model\Behavior\Timestampable;

class PipelineAnalysisExecutions extends \Phalcon\Mvc\Model
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
    public $pipeline_analysis_id;

    /**
     *
     * @var string
     */
    public $working_directory_path;

    /**
     *
     * @var integer
     */
    public $execution_user_id;

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
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id', 
            'pipeline_analysis_id' => 'pipeline_analysis_id', 
            'working_directory_path' => 'working_directory_path', 
            'execution_user_id' => 'execution_user_id', 
            'started_at' => 'started_at', 
            'finished_at' => 'finished_at', 
            'created_at' => 'created_at'
        );
    }

    public function initialize()
    {
        $this->addBehavior(new Timestampable(
            array(
                'beforeValidationOnCreate' => array(
                    'field' => 'created_at',
                    'format' => 'Y-m-d H:i:s'
                )
            )
        ));

    }

}
