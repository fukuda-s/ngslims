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

class Seqlibs extends \Phalcon\Mvc\Model
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
    public $sample_id;

    /**
     *
     * @var integer
     */
    public $project_id;

    /**
     *
     * @var integer
     */
    public $protocol_id;

    /**
     *
     * @var integer
     */
    public $oligobarcodeA_id;

    /**
     *
     * @var integer
     */
    public $oligobarcodeB_id;

    /**
     *
     * @var string
     */
    public $bioanalyser_chip_code;

    /**
     *
     * @var double
     */
    public $concentration;

    /**
     *
     * @var double
     */
    public $stock_seqlib_volume;

    /**
     *
     * @var integer
     */
    public $fragment_size;

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
            'sample_id' => 'sample_id',
            'project_id' => 'project_id',
            'protocol_id' => 'protocol_id',
            'oligobarcodeA_id' => 'oligobarcodeA_id',
            'oligobarcodeB_id' => 'oligobarcodeB_id',
            'bioanalyser_chip_code' => 'bioanalyser_chip_code',
            'concentration' => 'concentration',
            'stock_seqlib_volume' => 'stock_seqlib_volume',
            'fragment_size' => 'fragment_size',
            'started_at' => 'started_at',
            'finished_at' => 'finished_at',
            'created_at' => 'created_at'
        );
    }

    public function initialize()
    {
        $this->belongsTo('sample_id', 'Samples', 'id');
        $this->belongsTo('project_id', 'Projects', 'id');
        $this->belongsTo('protocol_id', 'Protocols', 'id');
        $this->belongsTo('oligobarcodeA_id', 'Oligobarcodes', 'id', array(
            'alias' => 'OligobarcodeA'
        ));
        $this->belongsTo('oligobarcodeB_id', 'Oligobarcodes', 'id', array(
            'alias' => 'OligobarcodeB'
        ));
        $this->belongsTo('id', 'StepEntries', 'seqlib_id', array(
            'alias' => 'StepEntries_BelongsTo'
        ));

        $this->hasMany('id', 'StepEntries', 'seqlib_id'); //It should be hasMany to use tied record on order.

        $this->hasManyToMany("id", "SeqtemplateAssocs", "seqlib_id", "seqtemplate_id", "Seqtemplates", "id");

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
