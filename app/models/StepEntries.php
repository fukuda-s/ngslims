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
    public $seqlib_id;

    /**
     *
     * @var integer
     */
    public $seqtemplate_id;

    /**
     *
     * @var integer
     */
    public $flowcell_id;

    /**
     *
     * @var string
     */
    public $step_phase_code;

    /**
     *
     * @var integer
     */
    public $step_id;

    /**
     *
     * @var integer
     */
    public $protocol_id;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     *
     * @var string
     */
    public $updated_at;

    /**
     *
     * @var string
     */
    public $status;

    /**
     *
     * @var integer
     */
    public $user_id;

    /**
     *
     * @var integer
     */
    public $update_user_id;

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
            'seqlib_id' => 'seqlib_id',
            'seqtemplate_id' => 'seqtemplate_id',
            'flowcell_id' => 'flowcell_id',
            'step_id' => 'step_id',
            'step_phase_code' => 'step_phase_code',
            'protocol_id' => 'protocol_id',
            'created_at' => 'created_at',
            'updated_at' => 'updated_at',
            'status' => 'status',
            'user_id' => 'user_id',
            'update_user_id' => 'update_user_id',
            'note' => 'note'
        );
    }

    public function initialize()
    {
        $this->belongsTo('sample_id', 'Samples', 'id');
        $this->belongsTo('seqlib_id', 'Seqlibs', 'id');
        $this->belongsTo('seqtemplate_id', 'Seqtemplates', 'id');
        $this->belongsTo('flowcell_id', 'Flowcells', 'id');

        $this->addBehavior(new Timestampable(
            array(
                'beforeValidationOnCreate' => array(
                    'field' => 'created_at',
                    'format' => 'Y-m-d H:i:s'
                ),
                'beforeUpdate' => array(
                    'field' => 'updated_at',
                    'format' => 'Y-m-d H:i:s'
                )
            )
        ));
    }
}
