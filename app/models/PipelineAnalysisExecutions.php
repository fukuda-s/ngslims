<?php
/**
 * (The MIT License)
 *
 * Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * 'Software'), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
