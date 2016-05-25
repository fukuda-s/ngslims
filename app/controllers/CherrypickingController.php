<?php
use Phalcon\Tag, Phalcon\Acl;

class CherrypickingController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateAfter('main');
        Tag::setTitle('Cherry-picking');
        parent::initialize();
    }

    public function indexAction()
    {
        $cherry_pickings = $this->modelsManager->createBuilder()
            ->columns(array(
                'COUNT(DISTINCT cps.seqlib_id) AS sample_count',
                'GROUP_CONCAT(sl.name) AS seqlib_names',
                'cp.*',
                'u.*'
            ))
            ->addFrom('CherryPickings', 'cp')
            ->join('CherryPickingSchemes', 'cps.cherry_picking_id = cp.id', 'cps')
            ->join('Seqlibs', 'sl.id = cps.seqlib_id', 'sl')
            ->join('Users', 'u.id = cp.user_id', 'u')
            ->where('cp.user_id = :user_id:', array("user_id" => $this->session->get('auth')['id']))
            ->groupBy(array('cp.id'))
            ->orderBy(array('cp.name DESC'))
            ->getQuery()
            ->execute();

        $this->view->setVar('cherry_pickings', $cherry_pickings);
    }

    public function showTubeSamplesAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_MAIN_LAYOUT);
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_AFTER_TEMPLATE);
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                $query = $this->request->getPost("pick_query", "striptags");

                $samples = $this->modelsManager->createBuilder()
                    ->columns(array('s.*', 'p.*', 'r.*', 'st.*', 'GROUP_CONCAT(sl.name) AS sl_names', 'sse.*', 'COUNT(sl.id) AS sl_count'))
                    ->addFrom('Samples', 's')
                    ->join('Projects', 'p.id = s.project_id', 'p')
                    ->join('Requests', 'r.id = s.request_id', 'r')
                    ->join('SampleTypes', 's.sample_type_id = st.id', 'st')
                    ->leftJoin('Seqlibs', 'sl.sample_id = s.id', 'sl')
                    ->leftJoin('StepEntries', 'sse.sample_id = s.id', 'sse')
                    ->where('s.name LIKE :query:', array("query" => '%' . $query . '%'))
                    ->groupBy('s.id')
                    ->orderBy('s.name ASC')
                    ->getQuery()
                    ->execute();

                $this->view->setVar('samples', $samples);
            }
        }
    }

    public function showTubeSeqlibsAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_MAIN_LAYOUT);
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_AFTER_TEMPLATE);
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                // echo "Request was made using POST and AJAX";
                $query = $this->request->getPost("pick_query", "striptags");
                $cherry_picking_id = $this->request->getPost("cherry_picking_id", "int");

                $seqlibs_tmp = $this->modelsManager->createBuilder()
                    ->columns(array('sl.*', 'se.*', 'pt.*', 'r.*', 'it.*', 'srmt.*', 'srrt.*', 'srct.*', 'COUNT(sta.id) AS sta_count'))
                    ->addFrom('Seqlibs', 'sl')
                    ->join('Samples', 's.id = sl.sample_id', 's')
                    ->join('Requests', 'r.id = s.request_id', 'r')
                    ->leftJoin('SeqRunTypeSchemes', 'r.seq_run_type_scheme_id = srts.id', 'srts')
                    ->leftJoin('InstrumentTypes', 'it.id = srts.instrument_type_id', 'it')
                    ->leftJoin('SeqRunmodeTypes', 'srmt.id = srts.seq_runmode_type_id', 'srmt')
                    ->leftJoin('SeqRunreadTypes', 'srrt.id = srts.seq_runread_type_id', 'srrt')
                    ->leftJoin('SeqRuncycleTypes', 'srct.id = srts.seq_runcycle_type_id', 'srct')
                    ->leftJoin('StepEntries', 'se.seqlib_id = sl.id', 'se')
                    ->leftJoin('Protocols', 'pt.id = sl.protocol_id', 'pt')
                    ->leftJoin('Steps', 'st.step_phase_code = pt.next_step_phase_code', 'st')
                    ->leftJoin('SeqtemplateAssocs', 'sta.seqlib_id = sl.id', 'sta');

                if ($query) {
                    $seqlibs_tmp = $seqlibs_tmp->where('s.name LIKE :query:', array("query" => '%' . $query . '%'));
                } elseif ($cherry_picking_id) {
                    $seqlibs_tmp = $seqlibs_tmp
                        ->leftJoin('CherryPickingSchemes', 'cps.seqlib_id = sl.id', 'cps')
                        ->where('cps.cherry_picking_id = :cherry_picking_id:', array("cherry_picking_id" => $cherry_picking_id));
                } else {
                    return false;
                }
                $seqlibs = $seqlibs_tmp->groupBy('sl.id, se.id, pt.id, r.id, it.id, srmt.id, srrt.id, srct.id, sta.id')
                    ->orderBy('sl.name ASC')
                    ->getQuery()
                    ->execute();

                $this->view->setVar('seqlibs', $seqlibs);
            }
        }
    }

    public function confirmAction()
    {
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            $seqlib_id_str = $this->request->getPost("cherrypick-seqlibs", "striptags");
            $seqlib_id = explode(",", $seqlib_id_str);
            $seqlibs = $this->modelsManager->createBuilder()
                ->columns(array('sl.*', 'se.*', 'pt.*', 'r.*', 'it.*', 'srmt.*', 'srrt.*', 'srct.*', 'COUNT(sta.id) AS sta_count'))
                ->addFrom('Seqlibs', 'sl')
                ->join('Samples', 's.id = sl.sample_id', 's')
                ->join('Requests', 'r.id = s.request_id', 'r')
                ->leftJoin('SeqRunTypeSchemes', 'r.seq_run_type_scheme_id = srts.id', 'srts')
                ->leftJoin('InstrumentTypes', 'it.id = srts.instrument_type_id', 'it')
                ->leftJoin('SeqRunmodeTypes', 'srmt.id = srts.seq_runmode_type_id', 'srmt')
                ->leftJoin('SeqRunreadTypes', 'srrt.id = srts.seq_runread_type_id', 'srrt')
                ->leftJoin('SeqRuncycleTypes', 'srct.id = srts.seq_runcycle_type_id', 'srct')
                ->leftJoin('StepEntries', 'se.seqlib_id = sl.id', 'se')
                ->leftJoin('Protocols', 'pt.id = sl.protocol_id', 'pt')
                ->leftJoin('Steps', 'st.step_phase_code = pt.next_step_phase_code', 'st')
                ->leftJoin('SeqtemplateAssocs', 'sta.seqlib_id = sl.id', 'sta')
                ->inWhere('sl.id', $seqlib_id)
                ->groupBy('sl.id, se.id, it.id, srmt.id, srrt.id, srct.id')
                ->orderBy('sl.name ASC')
                ->getQuery()
                ->execute();

            $this->view->setVar('seqlibs', $seqlibs);

            $pick_query = $this->request->getPost("pick_query_hidden", "striptags");
            $tube_filter = $this->request->getPost("tube-filter_hidden", "striptags");
            $this->view->setVar('previous_page', 'index?q=' . $pick_query . '&q_f=' . $tube_filter);


        } else {
            return $this->response->redirect('cherrypicking/index');
        }
    }

    public function cherryPickingSelectListAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_MAIN_LAYOUT);
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_AFTER_TEMPLATE);
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $auth = $this->session->get('auth');
                $cherry_pickings = $this->modelsManager->createBuilder()
                    ->columns(array('cp.id AS cp_id', 'CONCAT(cp.name, " (", COUNT(cps.id), ") -- ", cp.created_at) AS cp_name'))
                    ->addFrom('CherryPickings', 'cp')
                    ->leftJoin('CherryPickingSchemes', 'cp.id = cps.cherry_picking_id', 'cps')
                    ->where('cp.user_id = :user_id:', array("user_id" => $auth['id']))
                    ->groupBy('cp.id')
                    ->orderBy('cp.created_at DESC')
                    ->getQuery()
                    ->execute();

                echo Tag::select(array("cherry_pickings", $cherry_pickings, 'using' => array('cp_id', 'cp_name'), 'class' => 'form-control'));
            }
        }
    }

    public function createCherrypickingAction()
    {
        $this->view->disable();
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $cherrypickings = new CherryPickings();
                $cherrypickings->name = $request->getPost("cherrypicking_name", "striptags");
                $cherrypickings->user_id = $this->session->get('auth')['id'];
                $cherrypickings->active = 'Y';
                //$cherrypickings->created_at = '2014-02-07';

                $prev_cherrypickings = CherryPickings::find(array(
                    "name = :name: AND user_id = :user_id:",
                    'bind' => array(
                        'name' => $cherrypickings->name,
                        'user_id' => $cherrypickings->user_id
                    )
                ));

                if (!$prev_cherrypickings->count() > 0) {
                    if (!$cherrypickings->save()) {
                        foreach ($cherrypickings->getMessages() as $message) {
                            $this->flashSession->error((string)$message);
                        }
                        echo "Error: could not create new cherrypikcing list.";
                    } else {
                        echo "Success: cherrypicking list, '" . $cherrypickings->name . "' is created.";
                    }
                } else {
                    echo "Error: cherrypicking list, '" . $cherrypickings->name . "' is already exist.";
                }
            }
        }

    }

    public function saveCherrypickingAction()
    {
        $this->view->disable();
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $cherry_picking_id = $request->getPost("cherry_picking_id", "int");
                $seqlib_id_str = $request->getPost("seqlib_id_str", "striptags");
                $seqlib_ids = explode(",", $seqlib_id_str);

                $cherryPicking = CherryPickings::findFirst($cherry_picking_id);
                $cherryPickingSchemes = [];
                $i = 0;
                foreach ($seqlib_ids as $seqlib_id) {
                    $cherryPickingSchemes[$i] = new CherryPickingSchemes();
                    $cherryPickingSchemes[$i]->seqlib_id = $seqlib_id;
                    $cherryPickingSchemes[$i]->sample_id = Seqlibs::findFirst($seqlib_id)->sample_id;
                    $i++;
                }
                $cherryPicking->CherryPickingSchemes = $cherryPickingSchemes;
                if (!$cherryPicking->save()) {
                    foreach ($cherryPicking->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                } else {
                    $this->flashSession->success($cherryPicking->name . ' -- ' . $cherryPicking->created_at . ' has been added ' . count($cherryPickingSchemes) . ' seqlibs.');
                    //return $this->response->redirect('cherrypicking/index');
                }
            }
        }
    }
}
