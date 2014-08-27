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

    public function experimentsAction($code_step_phase)
    {
        Tag::appendTitle(' | Experiments ');
        // Get step and step_entry list and data
        $code_step_phase = $this->filter->sanitize($code_step_phase, array("string"));
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

        $step_id = $this->filter->sanitize($step_id, array("int"));

        $step = Steps::findFirst($step_id);
        $this->view->setVar('step', $step);

        $step_phase_code = $step->step_phase_code;
        if ($step_phase_code === 'QC') {
            //project|sample_count_all are needed when the sample|seqlib does not have step_entry record caused by bulk import.
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
                    Projects p ON p.pi_user_id = u.id AND p.active = 'Y'
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
            //project|sample_count_all are needed when the sample|seqlib does not have step_entry record caused by bulk import.
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
                    Projects p ON p.pi_user_id = u.id AND p.active = 'Y'
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
            //project|sample_count_all are needed when the sample|seqlib does not have step_entry record caused by bulk import.
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
                    Projects p ON p.pi_user_id = u.id AND p.active = 'Y'
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
                if ($seqlibs_all) {
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
        $request = $this->request;
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
            if (isset($selected_seqlibs[$selected_seqtemplate_index])) {
                foreach ($selected_seqlibs[$selected_seqtemplate_index] as $selected_seqlib) {
                    $seqlibs[$selected_seqlib['seqlib_id']] = Seqlibs::findFirstById($selected_seqlib['seqlib_id']);
                    $oligobarcodes[$selected_seqlib['oligobarcodeA_id']] = Oligobarcodes::findFirstById($selected_seqlib['oligobarcodeA_id']);
                    if (!empty($selected_seqlib['oligobarcodeB_id'])) {
                        $oligobarcodes[$selected_seqlib['oligobarcodeB_id']] = Oligobarcodes::findFirstById($selected_seqlib['oligobarcodeB_id']);
                    }
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

        $step = Steps::findFirst($step_id);
        $step_phase_code = $step->step_phase_code;

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
            $seqtemplate->name = $seqtemplate_prefix . '-' . $seqtemplate_serial_str;
            $seqtemplate->target_conc = $request->getPost('target_conc-' . $selected_seqtemplate_index);
            $seqtemplate->target_vol = $request->getPost('target_vol-' . $selected_seqtemplate_index);
            $seqtemplate->target_dw_vol = $request->getPost('dw_for_dilution_vol-' . $selected_seqtemplate_index);
            $seqtemplate->final_dw_vol = $request->getPost('added_dw_vol-' . $selected_seqtemplate_index);
            $seqtemplate->initial_vol = $request->getPost('library_vol_total-' . $selected_seqtemplate_index);
            $seqtemplate->initial_conc = $request->getPost('seqtemplate_initial_conc-' . $selected_seqtemplate_index);
            $seqtemplate->final_vol = $request->getPost('seqtemplate_final_vol-' . $selected_seqtemplate_index);
            $seqtemplate->final_conc = $request->getPost('seqtemplate_final_conc-' . $selected_seqtemplate_index);

            $seqtemplate_step_entries = array();
            $seqtemplate_step_entries[0] = new StepEntries;
            $seqtemplate_step_entries[0]->step_phase_code = $step_phase_code;
            $seqtemplate_step_entries[0]->step_id = $step_id;
            $seqtemplate_step_entries[0]->user_id = $this->session->get('auth')['id'];

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
                    //return;
                }
                $seqtemplate_assocs[$index] = new SeqtemplateAssocs();
                $seqtemplate_assocs[$index]->seqlib_id = $seqlib->id;
                $seqtemplate_assocs[$index]->conc_factor = $request->getPost('seqlib_conc_factor-' . $seqlib->id);
                $seqtemplate_assocs[$index]->input_vol = $request->getPost('seqlib_input_vol-' . $seqlib->id);

                $index++;
            }

            // Tied $seqtemplateAssocs array to $seqtemplate with using hasMany on Model/Seqtemplates.php
            $seqtemplate->SeqtemplateAssocs = $seqtemplate_assocs;
            // Tied $seqtemplate_step_entries array to $seqtemplate with using hasMany on Model/Seqtemplates.php
            $seqtemplate->StepEntries = $seqtemplate_step_entries;

            if (!$seqtemplate->save()) {
                foreach ($seqtemplate->getMessages() as $message) {
                    $this->flashSession->error((string)$message);
                }
                //return;
            } else {
                $this->flashSession->success($seqtemplate->name . " is saved with " . count($seqtemplate_assocs) . " seqlib(s).");
            }
        }

        // Remove session values which set at multiplex.volt with multiplexSetSessionAction (via ajax) and used on multiplexConfirmAction
        $this->session->remove('seqtemplates');
        $this->session->remove('indexedSeqlibs');

        return $this->response->redirect("tracker/experimentDetails/$step_id");
    }

    public function flowcellSetupCandidatesAction($step_id)
    {
        $this->view->cleanTemplateAfter()->setLayout('main');
        Tag::appendTitle(' | Flowcell Setup ');

        $step_id = $this->filter->sanitize($step_id, array("int"));
        $step = Steps::findFirst($step_id);
        $this->view->setVar('step', $step);

        $lane_per_flowcell = $step->getSeqRunmodeTypes()->lane_per_flowcell;
        $lane_index = range(1, $lane_per_flowcell);
        $this->view->setVar('lane_index', $lane_index);

        $seqtemplates = $this->modelsManager->createBuilder()
            ->columns(array('st.*', 'se.*'))
            ->addFrom('Seqtemplates', 'st')
            ->leftJoin('StepEntries', 'se.seqtemplate_id = st.id', 'se')
            ->orderBy(array('DATE(st.created_at) DESC', 'st.name ASC'))
            ->getQuery()
            ->execute();

        $this->view->setVar('seqtemplates', $seqtemplates);

        if ($seqlanes = $this->session->get('seqlanes')) {
            $this->view->setVar('seqlanes', $seqlanes);
        }

        if ($flowcell_name = $this->session->get('flowcell_name')) {
            $this->view->setVar('flowcell_name', $flowcell_name);
        }

        $controls = $step->getControls("active = 'Y'");
        $this->view->setVar('controls', $controls);
    }

    public function flowcellSetupSetSessionAction()
    {
        $this->view->disable();
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                if ($request->getPost('flowcell_clear') == 'true') {
                    $this->session->remove('flowcell_name');
                    $this->session->remove('seqlanes');
                }

                if ($request->hasPost('flowcell_name')) {
                    $flowcell_name = $request->getPost('flowcell_name');
                    $this->session->set('flowcell_name', $flowcell_name);
                }

                if ($request->hasPost('seqlanes')) {
                    $seqlanes = $request->getPost('seqlanes');
                    $this->session->set('seqlanes', $seqlanes);
                }
            }
        }

    }

    public function flowcellSetupConfirmAction($step_id)
    {
        $this->view->cleanTemplateAfter()->setLayout('main');
        Tag::appendTitle(' | Flowcell Setup Confirm');

        $step_id = $this->filter->sanitize($step_id, array("int"));
        $step = Steps::findFirst($step_id);
        $this->view->setVar('step', $step);

        $warn_flag = 0;
        $flowcell_name = $this->session->get('flowcell_name');
        if (!$flowcell_name) {
            $this->flashSession->error("Please input Flowcell ID!");
            $warn_flag++;
        }
        $this->view->setVar('flowcell_name', $flowcell_name);

        $flowcell_name_unique_check = Flowcells::findFirstByName($flowcell_name);
        if ($flowcell_name_unique_check) {
            $this->flashSession->error("Flowcell " . $flowcell_name . " is already existed. Please record with another Flowcell ID.");
            $warn_flag++;
        }

        $lane_per_flowcell = $step->getSeqRunmodeTypes()->lane_per_flowcell;
        $lane_index = range(1, $lane_per_flowcell);
        $this->view->setVar('lane_index', $lane_index);

        $seqlanes = $this->session->get('seqlanes');
        if (!$seqlanes) {
            $this->flashSession->error("Please set (drag and drop) seqtemplate(s) on Flowcell Lanes");
            $warn_flag++;
        }
        $this->view->setVar('seqlanes', $seqlanes);

        if ($warn_flag > 0) {
            return $this->response->redirect("tracker/flowcellSetupCandidates/$step_id");
        }

    }

    public function flowcellSetupSaveAction($step_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $flowcell_name = $this->session->get('flowcell_name');
                $flowcell_name = $this->filter->sanitize($flowcell_name, array("string"));


                $seqlanes = $this->session->get('seqlanes');

                if ($request->hasPost('seqlanes_add')) {
                    $seqlanes_add = $request->getPost('seqlanes_add');
                }

                $step_id = $this->filter->sanitize($step_id, array("int"));
                $step = Steps::findFirstById($step_id);

                $flowcell = new Flowcells();
                $flowcell->name = $flowcell_name;
                $flowcell->seq_runmode_type_id = $step->getSeqRunmodeTypes()->id;

                //Setup related StepEntries
                $flowcell_step_entries = array();
                $flowcell_step_entries[0] = new StepEntries;
                $flowcell_step_entries[0]->step_phase_code = $step->step_phase_code; //Should be FLOWCELL;
                $flowcell_step_entries[0]->step_id = $step_id;
                $flowcell_step_entries[0]->user_id = $this->session->get('auth')['id'];

                $flowcell->StepEntries = $flowcell_step_entries;

                //Setup related Seqlanes
                $seqlanes_model = array();
                foreach ($seqlanes as $index => $seqlane) {
                    $seqlanes_model[$index] = new Seqlanes();
                    $seqlanes_model[$index]->number = $this->filter->sanitize($seqlane["seqlane_number"], array("int"));

                    if (array_key_exists("seqtemplate_id", $seqlane)) {
                        $seqtemplate_id = $this->filter->sanitize($seqlane["seqtemplate_id"], array("int"));
                        $seqlanes_model[$index]->seqtemplate_id = $seqtemplate_id;
                    }

                    if (array_key_exists("control_id", $seqlane)) {
                        $control_id = $this->filter->sanitize($seqlane["control_id"], array("int"));
                        $seqlanes_model[$index]->control_id = $control_id;
                    }

                    $seqlanes_model[$index]->is_control = $this->filter->sanitize($seqlanes_add[$index]["is_control"], array("string"));

                    //If $seqlanes_add[$index]["apply_conc"] = null/not float, the sanitize filter returns fail.
                    if ($apply_conc = $this->filter->sanitize($seqlanes_add[$index]["apply_conc"], array("float"))) {
                        $seqlanes_model[$index]->apply_conc = $apply_conc;
                    }
                }
                //Tied $seqlanes_model(Seqlanes) array to $flowcell(Flowcells) with using hasMany relation on Flowcells model.
                $flowcell->Seqlanes = $seqlanes_model;

                if (!$flowcell->save()) {
                    foreach ($flowcell->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                    }
                    $this->flashSession->error("Flowcell " . $flowcell_name . " is not saved.");
                } else {
                    //Return json if success.
                    echo json_encode($flowcell);
                    $this->flashSession->success("Flowcell " . $flowcell_name . " is saved.");

                    $this->session->remove('flowcell_name');
                    $this->session->remove('seqlanes');
                }
            }
        }
    }

    public function flowcellAction($flowcell_id)
    {
        $this->view->cleanTemplateAfter()->setLayout('main');

        $flowcell_id = $this->filter->sanitize($flowcell_id, array("int"));
        $flowcell = Flowcells::findFirstById($flowcell_id);
        Tag::appendTitle(' | Flowcell ' . $flowcell->name);
        $this->view->setVar('flowcell', $flowcell);

        $lane_per_flowcell = $flowcell->getSeqRunmodeTypes()->lane_per_flowcell;
        $lane_index = range(1, $lane_per_flowcell);
        $this->view->setVar('lane_index', $lane_index);

        $seqlanes = array();
        foreach ($flowcell->getSeqlanes() as $seqlane) {
            $seqlanes[$seqlane->number] = $seqlane;
        }
        $this->view->setVar('seqlanes', $seqlanes);

    }

    public function sequenceAction()
    {
        Tag::appendTitle(' | Sequencing Run Setup ');
        $this->view->setVar('instrument_types', InstrumentTypes::find(array(
            "active = 'Y'",
            "order" => "sort_order IS NULL ASC, sort_order ASC"
        )));
    }

    public function sequenceSetupCandidatesAction($instrument_type_id)
    {
        $this->view->cleanTemplateAfter()->setLayout('main');
        Tag::appendTitle(' | Sequencing Run Setup ');

        $instrument_type_id = $this->filter->sanitize($instrument_type_id, array("int"));
        $instrument_type = InstrumentTypes::findFirst($instrument_type_id);
        $this->view->setVar('instrument_type', $instrument_type);
        $this->view->setVar('slots_per_run', range(1, $instrument_type->slots_per_run));

        $instruments = Instruments::find(array(
            "columns" => array(
                "id",
                "name",
                "CONCAT(name, ' (', instrument_number, ' : ', nickname, ')') AS fullname"
            ),
            "instrument_type_id = :instrument_type_id: AND active = 'Y'",
            'bind' => array(
                'instrument_type_id' => $instrument_type_id
            ),
            "order" => "instrument_number IS NULL ASC, instrument_number ASC"
        ));
        $this->view->setVar('instruments', $instruments);

        $phql_f = "
           SELECT
                se . *,
                fc . *,
                GROUP_CONCAT(DISTINCT(concat(it.id, '-', srmt.id, '-', srct.id, '-', srrt.id))) AS seqrun_prop_id,
                GROUP_CONCAT(DISTINCT(concat(it.name, ' ', srmt.name, ' ', srct.name, ' ', srrt.name))) AS seqrun_prop_name,
                fcsrmt.*
            FROM
                StepEntries se
                    LEFT JOIN
                StepInstrumentTypeSchemes sits ON sits.step_id = se.step_id
                    LEFT JOIN
                Flowcells fc ON fc.id = se.flowcell_id
                    LEFT JOIN
                Seqlanes sl ON sl.flowcell_id = fc.id
                    LEFT JOIN
                Seqtemplates st ON st.id = sl.seqtemplate_id
                    LEFT JOIN
                SeqtemplateAssocs sa ON sa.seqtemplate_id = st.id
                    LEFT JOIN
                Seqlibs slib ON slib.id = sa.seqlib_id
                    LEFT JOIN
                Samples s ON s.id = slib.sample_id
                    LEFT JOIN
                Requests r ON r.id = s.request_id
                    LEFT JOIN
                SeqRunTypeSchemes srts ON srts.id = r.seq_run_type_scheme_id
                    LEFT JOIN
                InstrumentTypes it ON it.id = srts.instrument_type_id
                    LEFT JOIN
                SeqRunmodeTypes srmt ON srmt.id = srts.seq_runmode_type_id
                    LEFT JOIN
                SeqRunreadTypes srrt ON srrt.id = srts.seq_runread_type_id
                    LEFT JOIN
                SeqRuncycleTypes srct ON srct.id = srts.seq_runcycle_type_id
                    LEFT JOIN
                SeqRunmodeTypes fcsrmt ON fcsrmt.id = fc.seq_runmode_type_id
            WHERE
                sits.instrument_type_id = :instrument_type_id:
            AND se.status IS NULL
            GROUP BY fc.id
            ORDER BY fc.created_at
        ";

        $flowcells = $this->modelsManager->executeQuery($phql_f, array(
            'instrument_type_id' => $instrument_type_id
        ));

        if(count($flowcells) < 1) {
            $this->flash->error("Any flowcells for " . $instrument_type->name . " does not available. Please set up flowcells before set up sequencing run.");
        }

        $this->view->setVar('flowcells', $flowcells);

        //Set session values to input forms.
        if ($this->session->has('instrument_id')) {
            Tag::setDefault('instrument_id', $this->session->get('instrument_id')->id);
        }
        /* @TODO Could not set default value at input:date form with setDefault?
         * if ($this->session->has('run_started_date')) {
         * //$this->flash->error($this->session->get('run_started_date'));
         * Tag::setDefault('run_started_date', $this->session->get('run_started_date')->name);
         * }
         */
    }

    public function sequenceSetupConfirmAction($instrument_type_id)
    {
        $this->view->cleanTemplateAfter()->setLayout('main');
        Tag::appendTitle(' | Sequencing Run Setup Confirm ');
        $request = $this->request;

        $warning = 0; // @TODO How to know flashSession is exist or not?

        $instrument_type_id = $this->filter->sanitize($instrument_type_id, array("int"));
        $instrument_type = InstrumentTypes::findFirst($instrument_type_id);
        $this->view->setVar('instrument_type', $instrument_type);

        $instrument_id = $request->getPost('instrument_id', array('string', 'int'));
        if (!$instrument_id) {
            $this->flashSession->warning("Please select Instrument");
            $warning++;
        } else {
            $instrument = Instruments::findFirst(array(
                $instrument_id,
                "columns" => array(
                    "id",
                    "name",
                    "CONCAT(name, ' (', instrument_number, ' : ', nickname, ')') AS fullname"
                ),
            ));
            $this->view->setVar('instrument', $instrument);
        }

        $run_started_date = $request->getPost('run_started_date', array('striptags'));
        if (!$run_started_date) {
            $this->flashSession->warning("Please input Run Started Date");
            $warning++;
        } else {
            $this->view->setVar('run_started_date', $run_started_date);
        }

        $seq_runmode_type_id = $request->getPost('seq_runmode_type', array('int'));
        if (!$seq_runmode_type_id) {
            $this->flashSession->warning("Please select Run Mode");
            $warning++;
        } else {
            $seq_runmode_type = SeqRunmodeTypes::findFirst($seq_runmode_type_id);
            $this->view->setVar('seq_runmode_type', $seq_runmode_type);
        }

        $slots_per_run = range(1, $instrument_type->slots_per_run);
        $this->view->setVar('slots_per_run', $slots_per_run);

        $slots_data = array();
        foreach ($slots_per_run as $slot) {
            $slot_unused = $request->getPost('slot_unused_' . $slot, array('striptags'));
            $slots_data[$slot]['slot_unused'] = $slot_unused;

            if ($slot_unused == 'on') {
                continue; //Skip if slot_unused is true
            }

            $run_number = $request->getPost('run_number_' . $slot, array('int'));
            if (!$run_number) {
                $this->flashSession->warning("Please select Run Number for Slot" . $slot);
                $warning++;
            } else {
                $slots_data[$slot]['run_number'] = $run_number;
            }

            $seq_runread_type_id = $request->getPost('seq_runread_type_' . $slot, array('int'));
            if (!$seq_runread_type_id) {
                $this->flashSession->warning("Please select Run Read Type for Slot" . $slot);
                $warning++;
            } else {
                $seq_runread_type = SeqRunreadTypes::findFirst($seq_runread_type_id);
                $slots_data[$slot]['seq_runread_type']['id'] = $seq_runread_type->id;
                $slots_data[$slot]['seq_runread_type']['name'] = $seq_runread_type->name;
            }

            $seq_runcycle_type_id = $request->getPost('seq_runcycle_type_' . $slot, array('int'));
            if (!$seq_runcycle_type_id) {
                $this->flashSession->warning("Please select Run Cycle for Slot" . $slot);
                $warning++;
            } else {
                $seq_runcycle_type = SeqRunCycleTypes::findFirst($seq_runcycle_type_id);
                $slots_data[$slot]['seq_runcycle_type']['id'] = $seq_runcycle_type->id;
                $slots_data[$slot]['seq_runcycle_type']['name'] = $seq_runcycle_type->name;
            }

            $flowcell_id = $request->getPost('flowcell_id_' . $slot, array('int'));
            if (!$flowcell_id) {
                $this->flashSession->warning("Please select Flowcell for Slot" . $slot);
                $warning++;
            } else {
                $flowcell = Flowcells::findFirst($flowcell_id);
                $slots_data[$slot]['flowcell']['id'] = $flowcell->id;
                $slots_data[$slot]['flowcell']['name'] = $flowcell->name;
            }

        }
        $this->view->setVar('slots_data', $slots_data);

        if ($warning > 0) {
            $this->flashSession->error($warning . " error(s).");
            return $this->response->redirect("tracker/sequenceSetupCandidates/" . $instrument_type->id);
        }

    }

    public function sequenceSetupSaveAction()
    {
        $this->view->disable();
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            $instrument_type_id = $request->getPost('instrument_type_id', array('int'));
            $instrument_type = InstrumentTypes::findFirst($instrument_type_id);
            $instrument_id = $request->getPost('instrument_id', array('int'));
            $instrument = Instruments::findFirst($instrument_id);

            $run_started_date = $request->getPost('run_started_date', array('striptags'));

            $seq_runmode_type_id = $request->getPost('seq_runmode_type_id', array('int'));

            $slots_per_run = range(1, $instrument_type->slots_per_run);
            $warning = 0;
            foreach ($slots_per_run as $slot) {
                $slot_unused = $request->getPost('slot_unused_' . $slot, array('striptags'));
                $slots_data[$slot]['slot_unused'] = $slot_unused;

                if ($slot_unused == 'on') {
                    continue; //Skip if slot_unused is true
                }

                $flowcell_id = $request->getPost('flowcell_id_' . $slot, array('int'));
                $flowcell = Flowcells::findFirst($flowcell_id);

                $seq_runread_type_id = $request->getPost('seq_runread_type_id_' . $slot, array('int'));
                $seq_runcycle_type_id = $request->getPost('seq_runcycle_type_id_' . $slot, array('int'));
                $seq_run_type_scheme_id = SeqRunTypeSchemes::findFirst(array(
                    "instrument_type_id = :instrument_type_id:
                        AND
                     seq_runmode_type_id = :seq_runmode_type_id:
                        AND
                     seq_runread_type_id = :seq_runread_type_id:
                        AND
                     seq_runcycle_type_id = :seq_runcycle_type_id:",
                    "bind" => array(
                        "instrument_type_id" => $instrument_type_id,
                        "seq_runmode_type_id" => $seq_runmode_type_id,
                        "seq_runread_type_id" => $seq_runread_type_id,
                        "seq_runcycle_type_id" => $seq_runcycle_type_id,
                    )
                ))->id;
                $run_number = $request->getPost('run_number_' . $slot, array('int'));
                $side = $instrument_type->getSlotStr($slot);
                $dirname = implode('_', array(
                        date('ymd', strtotime($run_started_date)),
                        $instrument->name,
                        $side . $flowcell->name
                    )
                );

                //Update Flowcells table
                $flowcell->seq_run_type_scheme_id = $seq_run_type_scheme_id;
                $flowcell->run_number = $run_number;
                $flowcell->instrument_id = $instrument_id;
                $flowcell->side = $side;
                $flowcell->dirname = $dirname;
                $flowcell->run_started_date = $run_started_date;

                //Update StepEntry table
                $step_entry = array();
                $step_entry[0] = StepEntries::findFirst(array(
                    "flowcell_id = :flowcell_id:",
                    "bind" => array(
                        "flowcell_id" => $flowcell_id
                    )
                ));
                $step_entry[0]->status = "Completed";
                $step_entry[0]->update_user_id = $this->session->get('auth')['id'];

                //Tied $step_entry as flowcell->StepEntry.
                $flowcell->StepEntries = $step_entry;

                //Update Seqlane table
                $seqlanes = $flowcell->Seqlanes;
                $seqlane_model = array();
                $index = 0;
                foreach ( $seqlanes as $seqlane) {
                    $seqlane_id = $seqlane->id;
                    $seqlane_model[$index] = Seqlanes::findFirst($seqlane_id);
                    $seqlane_model[$index]->first_cycle_date = $run_started_date;
                    $index++;
                }
                //Tied $seqlane as flowcell->Seqlane
                $flowcell->Seqlanes = $seqlane_model;


                if (!$flowcell->save()) {
                    foreach ($flowcell->getMessages() as $message) {
                        $this->flashSession->error((string)$message);
                        $warning++;
                    }
                } else {
                    $this->session->remove("run_number_" . $slot);
                    $this->session->remove("seq_runread_type_" . $slot);
                    $this->session->remove("seq_runcycle_type_" . $slot);
                    $this->session->remove("flowcell_id" . $slot);

                    $this->flashSession->notice("Sequence Run Setup has been recorded with flowcell ID " . $flowcell->name);
                }
            }
            if ($warning > 0) {
                $this->flashSession->warning($warning . " error(s) has been occurred.");
            } else {
                $this->session->remove("instrument_id");
                $this->session->remove("run_started_date");
                $this->session->remove("seq_runmode_type");
            }
            return $this->response->redirect("tracker/sequenceSetupCandidates/" . $instrument_type->id);
        }
    }

    public function protocolAction()
    {
        Tag::appendTitle(' | Protocols ');
    }
}
