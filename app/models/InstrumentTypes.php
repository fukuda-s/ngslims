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

class InstrumentTypes extends \Phalcon\Mvc\Model
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
    public $platform_code;

    /**
     *
     * @var integer
     */
    public $slots_per_run;

    /**
     *
     * @var string
     */
    public $slots_array_json;

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

    public function getSlotStr($slot_num) {
        $slots_array = json_decode($this->slots_array_json);
        return $slots_array->$slot_num;
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'id' => 'id',
            'name' => 'name',
            'platform_code' => 'platform_code',
            'slots_per_run' => 'slots_per_run',
            'slots_array_json' => 'slots_array_json',
            'sort_order' => 'sort_order',
            'active' => 'active'
        );
    }

    public function initialize()
    {
        $this->belongsTo('platform_code', 'Platforms', 'platform_code');

        $this->hasMany('id', 'Instruments', 'instrument_type_id');
        $this->hasMany('id', 'StepInstrumentTypeSchemes', 'instrument_type_id');

        $this->hasManyToMany("id", "SeqRunTypeSchemes", "instrument_type_id", "seq_runmode_type_id", "SeqRunmodeTypes", "id");
        $this->hasManyToMany("id", "SeqRunTypeSchemes", "instrument_type_id", "seq_runread_type_id", "SeqRunreadTypes", "id");
        $this->hasManyToMany("id", "SeqRunTypeSchemes", "instrument_type_id", "seq_runcycle_type_id", "SeqRuncycleTypes", "id");

        $this->addBehavior(new SoftDelete(
            array(
                'field' => 'active',
                'value' => InstrumentTypes::NOT_ACTIVE
            )
        ));
    }

}
