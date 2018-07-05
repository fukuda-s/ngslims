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

use Phalcon\Mvc\Model\Behavior\SoftDelete;

class Steps extends \Phalcon\Mvc\Model
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
     * @var string
     */
    public $short_name;

    /**
     *
     * @var string
     */
    public $step_phase_code;

    /**
     *
     * @var integer
     */
    public $seq_runmode_type_id;

    /**
     *
     * @var string
     */
    public $platform_code;
     
    /**
     *
     * @var string
     */
    public $nucleotide_type;
     
    /**
     *
     * @var integer
     */
    public $sort_order;
     
    /**
     *
     * @var string
     */
    public $active;

    const ACTIVE = 'Y';

    const NOT_ACTIVE = 'N';

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id', 
            'name' => 'name',
            'short_name' => 'short_name',
            'step_phase_code' => 'step_phase_code',
            'seq_runmode_type_id' => 'seq_runmode_type_id',
            'platform_code' => 'platform_code', 
            'nucleotide_type' => 'nucleotide_type', 
            'sort_order' => 'sort_order', 
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->belongsTo('seq_runmode_type_id', 'SeqRunmodeTypes', 'id');
        $this->belongsTo('nucleotide_type', 'SampleTypes', 'nucleotide_type');
        $this->belongsTo('step_phase_code', 'StepPhases', 'step_phase_code');
        $this->belongsTo('platform_code', 'Platforms', 'platform_code');
        $this->hasMany('platform_code', 'InstrumentTypes', 'platform_code');
        $this->hasMany('platform_code', 'Controls', 'platform_code');
        $this->hasMany('id', 'Protocols', 'step_id');
        $this->hasMany('id', 'StepEntries', 'step_id');

        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => Steps::NOT_ACTIVE
            )
        ));
    }

}
