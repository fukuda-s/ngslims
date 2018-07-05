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

class Flowcells extends \Phalcon\Mvc\Model
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
     * @var integer
     */
    public $seq_runmode_type_id;

    /**
     *
     * @var integer
     */
    public $seq_run_type_scheme_id;

    /**
     *
     * @var integer
     */
    public $run_number;

    /**
     *
     * @var integer
     */
    public $instrument_id;

    /**
     *
     * @var string
     */
    public $side;

    /**
     *
     * @var string
     */
    public $run_started_date;

    /**
     *
     * @var string
     */
    public $run_finished_date;

    /**
     *
     * @var string
     */
    public $dirname;

    /**
     *
     * @var string
     */
    public $created_at;

    /**
     *
     * @var string
     */
    public $notes;

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'name' => 'name',
            'seq_runmode_type_id' => 'seq_runmode_type_id',
            'seq_run_type_scheme_id' => 'seq_run_type_scheme_id',
            'run_number' => 'run_number',
            'instrument_id' => 'instrument_id',
            'side' => 'side',
            'run_started_date' => 'run_started_date',
            'run_finished_date' => 'run_finished_date',
            'dirname' => 'dirname',
            'created_at' => 'created_at',
            'notes' => 'notes'
        );
    }

    public function initialize()
    {
        $this->belongsTo('instrument_id', 'Instruments', 'id');
        $this->belongsTo('seq_runmode_type_id', 'SeqRunmodeTypes', 'id');
        $this->belongsTo('seq_run_type_scheme_id', 'SeqRunTypeSchemes', 'id');

        $this->hasMany('id', 'Seqlanes', 'flowcell_id');
        $this->hasMany('id', 'StepEntries', 'flowcell_id');
        $this->hasMany('id', 'SeqDemultiplexResults', 'flowcell_id');

        $this->hasManyToMany('id', 'Seqlanes', 'flowcell_id', 'seqtemplate_id', 'Seqtemplates', 'id');

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
