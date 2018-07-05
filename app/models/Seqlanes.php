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

class Seqlanes extends \Phalcon\Mvc\Model
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
    public $number;

    /**
     *
     * @var integer
     */
    public $flowcell_id;

    /**
     *
     * @var integer
     */
    public $seqtemplate_id;

    /**
     *
     * @var integer
     */
    public $number_sequencing_cycles_actual;

    /**
     *
     * @var string
     */
    public $filename;

    /**
     *
     * @var string
     */
    public $first_cycle_date;

    /**
     *
     * @var string
     */
    public $last_cycle_date;

    /**
     *
     * @var string
     */
    public $last_cycle_completed;

    /**
     *
     * @var string
     */
    public $last_cycle_failed;

    /**
     *
     * @var double
     */
    public $apply_conc;

    /**
     *
     * @var string
     */
    public $is_control;

    /**
     *
     * @var integer
     */
    public $control_id;

    /**
     *
     * @var double
     */
    public $q30_percent;

    /**
     *
     * @var integer
     */
    public $reads_total;

    /**
     *
     * @var integer
     */
    public $reads_passed_filter;

    /**
     *
     * @var integer
     */
    public $intensity;

    /**
     *
     * @var integer
     */
    public $intensity_sd;

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
            'number' => 'number',
            'flowcell_id' => 'flowcell_id',
            'seqtemplate_id' => 'seqtemplate_id',
            'number_sequencing_cycles_actual' => 'number_sequencing_cycles_actual',
            'filename' => 'filename',
            'first_cycle_date' => 'first_cycle_date',
            'last_cycle_date' => 'last_cycle_date',
            'last_cycle_completed' => 'last_cycle_completed',
            'last_cycle_failed' => 'last_cycle_failed',
            'apply_conc' => 'apply_conc',
            'is_control' => 'is_control',
            'control_id' => 'control_id',
            'q30_percent' => 'q30_percent',
            'reads_total' => 'reads_total',
            'reads_passed_filter' => 'reads_passed_filter',
            'intensity' => 'intensity',
            'intensity_sd' => 'intensity_sd',
            'created_at' => 'created_at'
        );
    }

    public function initialize()
    {
        $this->belongsTo('flowcell_id', 'Flowcells', 'id');
        $this->belongsTo('seqtemplate_id', 'Seqtemplates', 'id');
        $this->belongsTo('control_id', 'Controls', 'id');

        $this->hasMany('id', 'SeqDemultiplexResults', 'seqlane_id');

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
