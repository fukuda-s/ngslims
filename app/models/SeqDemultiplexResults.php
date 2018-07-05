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

class SeqDemultiplexResults extends \Phalcon\Mvc\Model
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
    public $seqlib_id;

    /**
     *
     * @var integer
     */
    public $seqlane_id;

    /**
     *
     * @var integer
     */
    public $flowcell_id;

    /**
     *
     * @var string
     */
    public $is_undetermined;

    /**
     *
     * @var integer
     */
    public $reads_total;

    /**
     *
     * @var integer
     */
    public $reads_passedfilter;

    /**
     *
     * @var string
     */
    public $software_version;

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
            'seqlib_id' => 'seqlib_id',
            'seqlane_id' => 'seqlane_id',
            'flowcell_id' => 'flowcell_id',
            'is_undetermined' => 'is_undetermined',
            'reads_total' => 'reads_total',
            'reads_passedfilter' => 'reads_passedfilter',
            'software_version' => 'software_version',
            'created_at' => 'created_at'
        );
    }

    public function initialize()
    {
        $this->belongsTo('seqlib_id', 'Seqlibs', 'id');
        $this->belongsTo('seqlane_id', 'Seqlanes', 'id');
        $this->belongsTo('flowcell_id', 'Flowcells', 'id');

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
