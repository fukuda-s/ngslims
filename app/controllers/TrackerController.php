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

            $oligobarcodes = $this->modelsManager->createBuilder()
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

            $this->view->setVar('oligobarcodes', $oligobarcodes);

            $seqlibs_inbarcode = array();
            $seqtemplates = array();
            foreach ($oligobarcodes as $oligobarcode) {
                $oligobarcodeA_id = $oligobarcode->o->id;
                $seqtemplate_id = 0;
                $seqtemplates[$seqtemplate_id] = 1;
                foreach ($seqlibs_all as $seqlib) {
                    if ($seqlib->sl->oligobarcodeA_id && $seqlib->sl->oligobarcodeA_id == $oligobarcodeA_id) {
                        if (!empty($seqlibs_inbarcode[$oligobarcodeA_id][$seqtemplate_id])) {
                            $seqtemplate_id++;
                            $seqtemplates[$seqtemplate_id] = 1;
                        }
                        $seqlibs_inbarcode[$oligobarcodeA_id][$seqtemplate_id] = $seqlib;
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
            }
        }

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
