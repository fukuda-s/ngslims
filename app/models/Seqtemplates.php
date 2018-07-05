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

class Seqtemplates extends \Phalcon\Mvc\Model
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
     * @var double
     */
    public $target_conc;

    /**
     *
     * @var double
     */
    public $target_vol;

    /**
     *
     * @var double
     */
    public $target_dw_vol;

    /**
     *
     * @var double
     */
    public $initial_conc;

    /**
     *
     * @var double
     */
    public $initial_vol;

    /**
     *
     * @var double
     */
    public $final_conc;

    /**
     *
     * @var double
     */
    public $final_vol;

    /**
     *
     * @var double
     */
    public $final_dw_vol;

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
            'name' => 'name',
            'target_conc' => 'target_conc',
            'target_vol' => 'target_vol',
            'target_dw_vol' => 'target_dw_vol',
            'initial_conc' => 'initial_conc',
            'initial_vol' => 'initial_vol',
            'final_conc' => 'final_conc',
            'final_vol' => 'final_vol',
            'final_dw_vol' => 'final_dw_vol',
            'started_at' => 'started_at',
            'finished_at' => 'finished_at',
            'created_at' => 'created_at'
        );
    }

    public function initialize()
    {
        $this->hasMany('id', 'SeqtemplateAssocs', 'seqtemplate_id');
        $this->hasMany('id', 'StepEntries', 'seqtemplate_id');
        $this->hasMany('id', 'Seqlanes', 'seqtemplate_id');

        $this->hasManyToMany('id', 'SeqtemplateAssocs', 'seqtemplate_id', 'seqlib_id', 'Seqlibs', 'id');


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
