<?php
use Phalcon\Tag, Phalcon\Acl;


class TrackerController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateAfter('main');
        Tag::setTitle('Sample Tracker');
        parent::initialize();
    }

    public function indexAction()
    {
        // return $this->forward("trackerProjects/piList");
    }

    public function projectAction()
    {
        Tag::appendTitle(' | Projects ');

        /* Get PI list and data */
        // @TODO Is it possible to get concatenated 'name' from getter on Users.php?
        $phql = "SELECT
					COUNT(DISTINCT p.id) AS project_count,
					COUNT(DISTINCT s.id) AS sample_count,
					u.id,
                    u.firstname,
                    u.lastname,
                    CONCAT(u.lastname, ', ', u.firstname) AS name
                 FROM
					Users u,
					Projects p,
					Samples s
				WHERE
					u.id = p.pi_user_id AND p.id = s.project_id
				GROUP BY (u.id)
				ORDER BY u.name ASC
				";
        $pi_users = $this->modelsManager->executeQuery($phql);

        // $this->flash->success(var_dump($users));
        $this->view->setVar('pi_users', $pi_users);
    }

    public function experimentsAction($code_step_phase)
    {
        Tag::appendTitle(' | Experiments ');
        // Get step and step_entry list and data
        $this->filter->sanitize($code_step_phase, array("string"));
        $phql = "
            SELECT
                COUNT(DISTINCT s.project_id) AS sample_project_count,
                COUNT(DISTINCT s.id) AS sample_count,
                COUNT(DISTINCT sl.project_id) AS seqlib_project_count,
                COUNT(DISTINCT sl.id) AS seqlib_count,
                st.id,
                st.name,
                st.step_phase_code
            FROM
                Steps st
                    LEFT JOIN
                StepEntries ste ON ste.step_id = st.id
                      AND ( ste.status != 'Completed' OR ste.status IS NULL )
                    LEFT JOIN
                Samples s ON s.id = ste.sample_id
                    LEFT JOIN
                Seqlibs sl ON sl.id = ste.seqlib_id
            WHERE
                st.step_phase_code LIKE :code_step_phase:
                    AND st.active = 'Y'
            GROUP BY st.id
            ORDER BY st.sort_order IS NULL ASC , st.sort_order ASC";
        $steps = $this->modelsManager->executeQuery($phql, array(
            'code_step_phase' => '%' . $code_step_phase . '%'
        ));

        $this->view->setVar('steps', $steps);
    }

    public function experimentDetailsAction($step_id)
    {
        $this->view->cleanTemplateAfter()->setLayout('main');
        //$this->view->setLayout('main');
        Tag::appendTitle(' | Experiments ');

        $this->filter->sanitize($step_id, array("int"));

        $step = Steps::findFirst($step_id);
        $this->view->setVar('step', $step);

        $step_phase_code = $step->step_phase_code;
        if ($step_phase_code === 'QC') {
            $phql = "
                SELECT
                    COUNT(DISTINCT s2.project_id) AS project_count,
                    COUNT(DISTINCT s2.id) AS sample_count,
                    COUNT(DISTINCT s.project_id) AS project_count_all,
                    COUNT(DISTINCT s.id) AS sample_count_all,
                    u.id,
                    u.firstname,
                    u.lastname,
                    CONCAT(u.lastname, ', ', u.firstname) AS name
                FROM
                    Users u
                        LEFT JOIN
                    Projects p ON p.pi_user_id = u.id
                        JOIN
                    Samples s ON s.project_id = p.id
                        LEFT JOIN
                    SampleTypes st ON st.id = s.sample_type_id
                        JOIN
                    Steps stp ON stp.nucleotide_type = st.nucleotide_type
                          AND st.nucleotide_type = :nucleotide_type:
                        LEFT JOIN
                    StepEntries ste ON ste.sample_id = s.id
                          AND ste.step_id = :step_id:
                          AND ( ste.status != 'Completed' OR ste.status IS NULL )
                        LEFT JOIN
                    Samples s2 ON s2.id = ste.sample_id
                GROUP BY u.id
                ORDER BY sample_count DESC, u.lastname ASC
            ";
            $pi_users = $this->modelsManager->executeQuery($phql, array(
                'step_id' => $step_id,
                'nucleotide_type' => $step->nucleotide_type
            ));
        } elseif ($step_phase_code === 'PREP') {
            $phql = "
                SELECT
                    COUNT(DISTINCT sl2.project_id) AS project_count,
                    COUNT(DISTINCT sl2.id) AS sample_count,
                    COUNT(DISTINCT s.project_id) AS project_count_all,
                    COUNT(DISTINCT s.id) AS sample_count_all,
                    u.id,
                    u.firstname,
                    u.lastname,
                    CONCAT(u.lastname, ', ', u.firstname) AS name
                FROM
                    Users u
                        LEFT JOIN
                    Projects p ON p.pi_user_id = u.id
                        JOIN
                    Seqlibs sl ON sl.project_id = p.id
                        JOIN
                    Samples s ON s.id = sl.sample_id
                        JOIN
                    SampleTypes st ON st.id = s.sample_type_id
                        JOIN
                    Steps stp ON stp.nucleotide_type = st.nucleotide_type
                          AND st.nucleotide_type = :nucleotide_type:
                        LEFT JOIN
                    StepEntries ste ON ste.seqlib_id = sl.id
                          AND ste.step_id = :step_id:
                          AND ( ste.status != 'Completed' OR ste.status IS NULL )
                        LEFT JOIN
                    Seqlibs sl2 ON sl2.id = ste.seqlib_id
                GROUP BY u.id
                ORDER BY sample_count DESC, u.lastname ASC
            ";
            $pi_users = $this->modelsManager->executeQuery($phql, array(
                'step_id' => $step_id,
                'nucleotide_type' => $step->nucleotide_type
            ));
        } elseif ($step_phase_code === 'MULTIPLEX' || $step_phase_code === 'DUALMULTIPLEX') {
            $phql = "
                SELECT
                    COUNT(DISTINCT sl2.project_id) AS project_count,
                    COUNT(DISTINCT sl2.id) AS sample_count,
                    COUNT(DISTINCT sl.project_id) AS project_count_all,
                    COUNT(DISTINCT sl.id) AS sample_count_all,
                    u.id,
                    u.firstname,
                    u.lastname,
                    CONCAT(u.lastname, ', ', u.firstname) AS name
                FROM
                    Users u
                        LEFT JOIN
                    Projects p ON p.pi_user_id = u.id
                        JOIN
                    Seqlibs sl ON sl.project_id = p.id
                        JOIN
                    Protocols pt ON pt.id = sl.protocol_id
                        AND pt.next_step_phase_code = :next_step_phase_code:
                        LEFT JOIN
                    StepEntries se ON se.seqlib_id = sl.id AND se.status = 'Completed'
                        LEFT JOIN
                    Seqlibs sl2 ON sl2.id = se.seqlib_id
                GROUP BY u.id
                ORDER BY sample_count DESC, u.lastname ASC
            ";
            $pi_users = $this->modelsManager->executeQuery($phql, array(
                'next_step_phase_code' => $step_phase_code
            ));
        }

        // $this->flash->success(var_dump($pi_users));
        $this->view->setVar('pi_users', $pi_users);
    }

    public function multiplexAction($step_id)
    {
        $this->view->cleanTemplateAfter()->setLayout('main');
        Tag::appendTitle(' | Multiplexing ');

        $step = Steps::findFirst($step_id);
        $this->view->setVar('step', $step);
        $step_phase_code = $step->step_phase_code;

        $seqlib_ids = $this->session->get('selectedSeqlibs');
        if (!$seqlib_ids) {
            $this->flash->warning("Couldn't find any selected seqlibs.");
        }
        $seqlibs_all = $this->modelsManager->createBuilder()
            ->columns(array('sl.*', 'se.*'))
            ->addFrom('Seqlibs', 'sl')
            ->leftJoin('StepEntries', 'se.seqlib_id = sl.id', 'se')
            ->inWhere('sl.id', $seqlib_ids)
            ->getQuery()
            ->execute();

        if ($step_phase_code === 'MULTIPLEX') {
            // @TODO Is seqlib_nobarcode able to generate from $seqlib_all?
            $seqlibs_nobarcode = $this->modelsManager->createBuilder()
                ->columns(array('sl.*', 'se.*'))
                ->addFrom('Seqlibs', 'sl')
                ->leftJoin('StepEntries', 'se.seqlib_id = sl.id', 'se')
                ->inWhere('sl.id', $seqlib_ids)
                ->andWhere('sl.oligobarcodeA_id IS NULL')
                ->getQuery()
                ->execute();

            //$this->flash->success(var_dump($seqlibs));
            $this->view->setVar('seqlibs_nobarcode', $seqlibs_nobarcode);

            $oligobarcodeAs = $this->modelsManager->createBuilder()
                ->columns(array('o.*', 'os.*'))
                ->addFrom('Oligobarcodes', 'o')
                ->leftJoin('OligobarcodeSchemes', 'os.id = o.oligobarcode_scheme_id AND os.active = "Y"', 'os')
                ->leftJoin('OligobarcodeSchemeAllows', 'osa.oligobarcode_scheme_id = os.id', 'osa')
                ->leftJoin('Seqlibs', 'sl.protocol_id = osa.protocol_id', 'sl')
                ->inWhere('sl.id', $seqlib_ids)
                ->andWhere('o.active = "Y"')
                ->orderBy('os.id ASC, o.sort_order ASC')
                ->groupBy('o.id')
                ->getQuery()
                ->execute();

            $this->view->setVar('oligobarcodeAs', $oligobarcodeAs);

            /*
             * Create 2D array $seqlibs_inbarcode which has oligobarcodeA_id
             *  Row: oligobarcodeA
             *  Col: seqtemplates
             */
            $seqlibs_inbarcode = array();
            $seqtemplates = array();
            foreach ($oligobarcodeAs as $oligobarcodeA) {
                $oligobarcodeA_id = $oligobarcodeA->o->id;
                $seqtemplate_index = 1;
                $seqtemplates[$seqtemplate_index] = 1;
                foreach ($seqlibs_all as $seqlib) {
                    if ($seqlib->sl->oligobarcodeA_id && $seqlib->sl->oligobarcodeA_id == $oligobarcodeA_id) {
                        if (!empty($seqlibs_inbarcode[$seqtemplate_index][$oligobarcodeA_id])) {
                            $seqtemplate_index++;
                            $seqtemplates[$seqtemplate_index] = 1;
                        }
                        $seqlibs_inbarcode[$seqtemplate_index][$oligobarcodeA_id] = $seqlib;
                    }
                }
            }
            //var_dump($seqlibs_inbarcode);
            $this->view->setVar('seqlibs_inbarcode', $seqlibs_inbarcode);
            $this->view->setVar('seqtemplates', $seqtemplates);
        } elseif ($step_phase_code === 'DUALMULTIPLEX') {
            // @TODO Is seqlib_nobarcode able to generate from $seqlib_all?
            $seqlibs_nobarcode = $this->modelsManager->createBuilder()
                ->columns(array('sl.*', 'se.*'))
                ->addFrom('Seqlibs', 'sl')
                ->leftJoin('StepEntries', 'se.seqlib_id = sl.id', 'se')
                ->inWhere('sl.id', $seqlib_ids)
                ->andWhere('(sl.oligobarcodeA_id IS NULL OR sl.oligobarcodeB_id IS NULL)')
                ->getQuery()
                ->execute();

            $this->view->setVar('seqlibs_nobarcode', $seqlibs_nobarcode);

            $oligobarcodeAs = $this->modelsManager->createBuilder()
                ->columns(array('o.*', 'os.*'))
                ->addFrom('Oligobarcodes', 'o')
                ->leftJoin('OligobarcodeSchemes', 'os.id = o.oligobarcode_scheme_id AND os.active = "Y"', 'os')
                ->leftJoin('OligobarcodeSchemeAllows', 'osa.oligobarcode_scheme_id = os.id', 'osa')
                ->leftJoin('Seqlibs', 'sl.protocol_id = osa.protocol_id', 'sl')
                ->inWhere('sl.id', $seqlib_ids)
                ->andWhere('o.active = "Y"')
                ->andWHere("os.is_oligobarcodeB = 'N'")
                ->orderBy('os.id ASC, o.sort_order ASC')
                ->groupBy('o.id')
                ->getQuery()
                ->execute();

            $oligobarcodeBs = $this->modelsManager->createBuilder()
                ->columns(array('o.*', 'os.*'))
                ->addFrom('Oligobarcodes', 'o')
                ->leftJoin('OligobarcodeSchemes', 'os.id = o.oligobarcode_scheme_id AND os.active = "Y"', 'os')
                ->leftJoin('OligobarcodeSchemeAllows', 'osa.oligobarcode_scheme_id = os.id', 'osa')
                ->leftJoin('Seqlibs', 'sl.protocol_id = osa.protocol_id', 'sl')
                ->inWhere('sl.id', $seqlib_ids)
                ->andWhere('o.active = "Y"')
                ->andWHere("os.is_oligobarcodeB = 'Y'")
                ->orderBy('os.id ASC, o.sort_order ASC')
                ->groupBy('o.id')
                ->getQuery()
                ->execute();

            $this->view->setVar('oligobarcodeAs', $oligobarcodeAs);
            $this->view->setVar('oligobarcodeBs', $oligobarcodeBs);

            /*
             * Create 3D array $seqlibs_inbarcode which has oligobarcodeA_id and oligobarcodeB_id
             * (Table: seqtemplates)
             *  Row: oligobarcodeB
             *  Col: oligobarcodeA
             */
            $seqlibs_inbarcode = array();
            $seqtemplates = array();
            foreach ($oligobarcodeBs as $oligobarcodeB) {
                $oligobarcodeB_id = $oligobarcodeB->o->id;
                foreach ($oligobarcodeAs as $oligobarcodeA) {
                    $oligobarcodeA_id = $oligobarcodeA->o->id;
                    $seqtemplate_index = 1;
                    $seqtemplates[$seqtemplate_index] = 1;
                    foreach ($seqlibs_all as $seqlib) {
                        if ($seqlib->sl->oligobarcodeB_id && $seqlib->sl->oligobarcodeB_id == $oligobarcodeB_id && $seqlib->sl->oligobarcodeA_id && $seqlib->sl->oligobarcodeA_id == $oligobarcodeA_id) {
                            if (!empty($seqlibs_inbarcode[$seqtemplate_index][$oligobarcodeB_id][$oligobarcodeA_id])) {
                                $seqtemplate_index++;
                                $seqtemplates[$seqtemplate_index] = 1;
                            }
                            $seqlibs_inbarcode[$seqtemplate_index][$oligobarcodeB_id][$oligobarcodeA_id] = $seqlib;
                        }
                    }
                }
            }
            //var_dump($seqlibs_inbarcode);
            $this->view->setVar('seqlibs_inbarcode', $seqlibs_inbarcode);
            $this->view->setVar('seqtemplates', $seqtemplates);
        }
    }

    public function multiplexSetSessionAction()
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                if ($request->hasPost('selectedSeqlibs')) {
                    $selectedSeqlibs = $request->getPost('selectedSeqlibs');
                    //$this->session->remove('selectedSeqlibs');
                    $this->session->set('selectedSeqlibs', $selectedSeqlibs);
                    echo json_encode($selectedSeqlibs);
                }
                if ($request->hasPost('indexedSeqlibs')) {
                    $indexedSeqlibs = $request->getPost('indexedSeqlibs');
                    $seqtemplates = $request->getPost('seqtemplates');
                    //$this->session->remove('indexedSeqlibs');
                    $this->session->set('indexedSeqlibs', $indexedSeqlibs);
                    $this->session->set('seqtemplates', $seqtemplates);
                    echo json_encode($indexedSeqlibs);
                }
            }
        }
    }

    public function multiplexConfirmAction($step_id)
    {
        $this->view->cleanTemplateAfter()->setLayout('main');
        Tag::appendTitle(' | Multiplex Confirm ');

        $selected_seqtemplates = $this->session->get('seqtemplates');
        $selected_seqlibs = $this->session->get('indexedSeqlibs');
        //var_dump($selected_seqtemplates);
        $this->view->setVar('selected_seqtemplates', $selected_seqtemplates);
        //var_dump($selected_seqlibs);
        $this->view->setVar('selected_seqlibs', $selected_seqlibs);

        $seqlibs = array();
        $oligobarcodes = array();
        foreach ($selected_seqtemplates as $selected_seqtemplate_index) {
            foreach ($selected_seqlibs[$selected_seqtemplate_index] as $selected_seqlib) {
                $seqlibs[$selected_seqlib['seqlib_id']] = Seqlibs::findFirstById($selected_seqlib['seqlib_id']);
                $oligobarcodes[$selected_seqlib['oligobarcodeA_id']] = Oligobarcodes::findFirstById($selected_seqlib['oligobarcodeA_id']);
                if (!empty($selected_seqlib['oligobarcodeB_id'])) {
                    $oligobarcodes[$selected_seqlib['oligobarcodeB_id']] = Oligobarcodes::findFirstById($selected_seqlib['oligobarcodeB_id']);
                }
            }
        }
        $this->view->setVar('seqlibs', $seqlibs);
        $this->view->setVar('oligobarcodes', $oligobarcodes);
        $this->view->setVar('step_id', $step_id);
    }

    public function multiplexSaveAction($step_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();

        /*
         * Find today's last seqtemplate name (ex. INDEX20140312-001)
         */
        $seqtemplate_prefix = 'INDEX' . date('Ymd');
        $prev_seqtemplates = Seqtemplates::find(array(
            'conditions' => "name LIKE :name:",
            'bind' => array(
                'name' => $seqtemplate_prefix . '%'
            ),
            'order' => 'name'
        ));

        $prev_seqtemplate_last = $prev_seqtemplates->getLast();
        $prev_seqtemplate_serial = 0;
        if ($prev_seqtemplate_last) {
            $prev_seqtemplate_serial_array = preg_split('/-/', $prev_seqtemplate_last->name);
            if (count($prev_seqtemplate_serial_array) > 1) {
                $prev_seqtemplate_serial = end($prev_seqtemplate_serial_array);
            }
        }


        /*
         * Save Seqtemplates, SeqtemplateAssocs and Seqlibs
         */
        $selected_seqtemplates = $this->session->get('seqtemplates');
        $selected_seqlibs = $this->session->get('indexedSeqlibs');
        $seqtemplate_serial = $prev_seqtemplate_serial;
        foreach ($selected_seqtemplates as $selected_seqtemplate_index) {
            $seqtemplate_serial++;
            $seqtemplate_serial_str = sprintf("%03d", $seqtemplate_serial);

            $seqtemplate = new Seqtemplates();
            $seqtemplate->name = $seqtemplate_prefix.'-'.$seqtemplate_serial_str;
            $seqtemplate->target_conc = $request->getPost('target_conc-'.$selected_seqtemplate_index);
            $seqtemplate->target_vol = $request->getPost('target_vol-'.$selected_seqtemplate_index);
            $seqtemplate->target_dw_vol = $request->getPost('dw_for_dilution_vol-'.$selected_seqtemplate_index);
            $seqtemplate->final_dw_vol = $request->getPost('added_dw_vol-'.$selected_seqtemplate_index);
            $seqtemplate->initial_vol = $request->getPost('library_vol_total-'.$selected_seqtemplate_index);
            $seqtemplate->initial_conc = $request->getPost('seqtemplate_initial_conc-'.$selected_seqtemplate_index);
            $seqtemplate->final_vol = $request->getPost('seqtemplate_final_vol-'.$selected_seqtemplate_index);
            $seqtemplate->final_conc = $request->getPost('seqtemplate_final_conc-'.$selected_seqtemplate_index);

            $index = 0;
            $seqtemplate_assocs = array();
            foreach ($selected_seqlibs[$selected_seqtemplate_index] as $selected_seqlib) {
                $seqlib = Seqlibs::findFirstById($selected_seqlib['seqlib_id']);
                $seqlib->oligobarcodeA_id = $selected_seqlib['oligobarcodeA_id'];
                if (!empty($selected_seqlib['oligobarcodeB_id'])) {
                    $seqlib->oligobarcodeB_id = $selected_seqlib['oligobarcodeB_id'];
                }
                if (!$seqlib->save()) {
                    foreach ($seqlib->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    return;
                }
                $seqtemplate_assocs[$index] = new SeqtemplateAssocs();
                $seqtemplate_assocs[$index]->seqlib_id = $seqlib->id;
                $seqtemplate_assocs[$index]->conc_factor = $request->getPost('seqlib_conc_factor-'.$seqlib->id);
                $seqtemplate_assocs[$index]->input_vol = $request->getPost('seqlib_input_vol-'.$seqlib->id);

                $index++;
            }
            $seqtemplate->SeqtemplateAssocs = $seqtemplate_assocs;
            if (!$seqtemplate->save()) {
                foreach ($seqtemplate->getMessages() as $message) {
                    $this->flashSession->error((string)$message);
                }
                return;
            }

            $this->flashSession->success($seqtemplate->name." is saved with ".count($seqtemplate_assocs)." seqlib(s).");
        }

        // Remove session values which set at multiplex.volt with multiplexSetSessionAction (via ajax) and used on multiplexConfirmAction
        $this->session->remove('seqtemplates');
        $this->session->remove('indexedSeqlibs');

        return $this->response->redirect("tracker/experimentDetails/$step_id");
    }

    public function sequenceAction()
    {
        Tag::appendTitle(' | Sequence Runs ');
        $this->view->setVar('instrument_types', InstrumentTypes::find(array(
            "active = 'Y'",
            "order" => "sort_order IS NULL ASC, sort_order ASC"
        )));
    }

    public function protocolAction()
    {
        Tag::appendTitle(' | Protocols ');
    }
}
