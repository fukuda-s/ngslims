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

use Phalcon\Tag, Phalcon\Acl;

class SearchController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateAfter('main');
        Tag::setTitle('Search Results');
        parent::initialize();
    }

    public function indexAction()
    {
    }

    public function resultAction()
    {
        $this->assets
            ->addJs('js/DataTables/datatables.min.js')
            ->addCss('js/DataTables/datatables.min.css');

        $request = $this->request;

        $query = $request->get('q', 'striptags');
        if (empty($query)) {
            $this->flashSession->warning("Please input search words.");
            return $this->response->redirect("search/index");
        }
        $this->view->setVar('query', $query);
        $terms = preg_split('/[\s|\x{3000}]+/u', $query);
        $this->flash->success('Search by "' . $query . '"');

        /*
         * Get data to display table withusing $year and $month
         */
        $result_tmp = $this->modelsManager->createBuilder()
            ->columns(array('slane.*', 'sl.*', 's.*', 'p.*', 'sta.*', 'st.*', 'fc.*', 'it.*', 'srmt.*', 'srrt.*', 'srct.*', 'sdr.*'))
            ->addFrom('Samples', 's')
            ->join('Projects', 'p.id = s.project_id', 'p')
            ->leftJoin('Seqlibs', 'sl.sample_id = s.id', 'sl')
            ->leftJoin('SeqtemplateAssocs', 'sta.seqlib_id = sl.id', 'sta')
            ->leftJoin('Seqtemplates', 'st.id = sta.seqtemplate_id', 'st')
            ->leftJoin('Seqlanes', 'slane.seqtemplate_id = st.id', 'slane')
            ->leftJoin('Flowcells', 'fc.id = slane.flowcell_id', 'fc')
            ->leftJoin('SeqRunTypeSchemes', 'srts.id = fc.seq_run_type_scheme_id', 'srts')
            ->leftJoin('InstrumentTypes', 'it.id = srts.instrument_type_id', 'it')
            ->leftJoin('SeqRunmodeTypes', 'srmt.id = srts.seq_runmode_type_id', 'srmt')
            ->leftJoin('SeqRunreadTypes', 'srrt.id = srts.seq_runread_type_id', 'srrt')
            ->leftJoin('SeqRuncycleTypes', 'srct.id = srts.seq_runcycle_type_id', 'srct')
            ->leftJoin('SeqDemultiplexResults', 'sdr.seqlib_id = sl.id AND sdr.seqlane_id = slane.id', 'sdr');

        foreach ($terms as $term) {
            $result_tmp = $result_tmp
                ->orWhere('p.name LIKE :query:', array("query" => '%' . $term . '%'))
                ->orWhere('s.name LIKE :query:', array("query" => '%' . $term . '%'))
                ->orWhere('sl.name LIKE :query:', array("query" => '%' . $term . '%'))
                ->orWhere('st.name LIKE :query:', array("query" => '%' . $term . '%'))
                ->orWhere('fc.name LIKE :query:', array("query" => '%' . $term . '%'));
        }
        $result = $result_tmp->orderBy(array(
            'p.name',
            'fc.run_started_date',
            'fc.run_number',
            'slane.number',
            'sl.oligobarcodeA_id',
            'sl.oligobarcodeB_id'
        ))
            ->getQuery()
            ->execute();
        $this->view->setVar('result', $result);

    }

}
