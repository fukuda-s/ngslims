<?php
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
            ->addJs('js/DataTables-1.10.4/media/js/jquery.dataTables.min.js')
            ->addJs('js/DataTables-1.10.4/extensions/TableTools/js/dataTables.tableTools.min.js')
            ->addJs('js/DataTables-1.10.4/examples/resources/bootstrap/3/dataTables.bootstrap.js')
            ->addCss('js/DataTables-1.10.4/media/css/jquery.dataTables.min.css')
            ->addCss('js/DataTables-1.10.4/extensions/TableTools/css/dataTables.tableTools.min.css')
            ->addCss('js/DataTables-1.10.4/examples/resources/bootstrap/3/dataTables.bootstrap.css');

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
            ->columns(array('slane.*', 'sl.*', 's.*', 'p.*', 'sta.*', 'fc.*', 'it.*', 'srmt.*', 'srrt.*', 'srct.*', 'sdr.*'))
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
