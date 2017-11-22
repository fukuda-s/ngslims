<?php
use Phalcon\Tag, Phalcon\Acl, Phalcon\Mvc\View;


class SummaryController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateAfter('main');
        Tag::setTitle('Sample Summary');
        parent::initialize();
    }

    public function indexAction()
    {
        // return $this->forward("trackerProjects/piList");
    }

    public function projectPiAction()
    {
        Tag::appendTitle(' | Project Summary By PIs ');

        /* Get PI list and data */
        $pi_users = Users::find(array(
            "order" => "lastname ASC, firstname ASC"
        ));

        // $this->flash->success(var_dump($users));
        $this->view->setVar('pi_users', $pi_users);
    }

    public function projectNameAction()
    {
        Tag::appendTitle(' | Project Summary By Project Name');

        $projects = Projects::find(array(
            "order" => 'name'
        ));
        $this->view->setVar('projects', $projects);
    }

    public function projectNameProgressAction()
    {
        $this->view->setRenderLevel(View::LEVEL_ACTION_VIEW);
        $request = $this->request;
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                if ($request->hasPost('project_id')) {
                    $project_id = $request->getPost('project_id', 'int');
                    $project = Projects::findFirst($project_id);
                    $this->view->setVar('project', $project);

                    /*
                     * Count progress status of Samples QC on project.
                     */
                    $samples_progress = $this->modelsManager->createBuilder()
                        ->columns(array(
                            "COUNT(DISTINCT s.id) AS all_sum",
                            "SUM(se.status = 'Completed' OR s.qual_date IS NOT NULL) AS completed_sum",
                            "SUM(se.status = 'In Progress') AS inprogress_sum",
                            "SUM(se.status = 'On Hold') AS onhold_sum"
                        ))
                        ->addFrom('Samples', 's')
                        ->leftJoin('StepEntries', "se.sample_id = s.id AND se.step_phase_code = 'QC'", 'se')
                        ->where('s.project_id = :project_id:')
                        ->getQuery()
                        ->execute(array(
                            "project_id" => $project_id
                        ));
                    $this->view->setVar('samples_progress', $samples_progress);

                    /*
                     * Count progress status of Seqlibs PREP on project.
                     */
                    $seqlibs_progress = $this->modelsManager->createBuilder()
                        ->columns(array(
                            "COUNT(DISTINCT sl.id) AS all_sum",
                            "SUM(se.status = 'Completed' OR sl.finished_at IS NOT NULL) AS completed_sum",
                            "SUM(se.status = 'In Progress') AS inprogress_sum",
                            "SUM(se.status = 'On Hold') AS onhold_sum"
                        ))
                        ->addFrom('Seqlibs', 'sl')
                        ->leftJoin('StepEntries', "se.seqlib_id = sl.id AND se.step_phase_code = 'PREP'", 'se')
                        ->where('sl.project_id = :project_id:')
                        ->getQuery()
                        ->execute(array(
                            "project_id" => $project_id
                        ));
                    $this->view->setVar('seqlibs_progress', $seqlibs_progress);

                    /*
                     * Count progress status of Seqlanes FLOWCELL on project.
                     */
                    $seqlanes_progress = $this->modelsManager->createBuilder()
                        ->columns(array(
                            "COUNT(DISTINCT sl.id) AS all_sum",
                            "SUM(se.status = 'Completed'
                                OR slane.last_cycle_date IS NOT NULL) AS completed_sum",
                            "SUM(se.status = 'In Progress'
                                OR (se.id IS NULL
                                    AND slane.first_cycle_date IS NOT NULL
                                    AND slane.last_cycle_date IS NULL)) AS inprogress_sum",
                            "SUM(se.status = 'On Hold') AS onhold_sum"
                        ))
                        ->addFrom('Seqlibs', 'sl')
                        ->leftJoin('SeqtemplateAssocs', 'sta.seqlib_id = sl.id', 'sta')
                        ->leftJoin('Seqlanes', 'slane.seqtemplate_id = sta.seqtemplate_id', 'slane')
                        ->leftJoin('Flowcells', 'fc.id = slane.flowcell_id', 'fc')
                        ->leftJoin('StepEntries', "se.flowcell_id = fc.id AND se.step_phase_code = 'FLOWCELL'", 'se')
                        ->where('sl.project_id = :project_id:')
                        ->groupBy('sl.id')
                        ->getQuery()
                        ->execute(array(
                            "project_id" => $project_id
                        ));

                    /*
                     * The above result of $seqlane"s"_progress like as follows. (each line each seqlib)
                     *  <seqlib>    all_sum completed_sum   inprogress_sum  onhold_sum
                     *  (seqlib1)   1	3	2	0
                     *  (seqlib2)   1	0	1	1
                     *  (seqlib3)   1	1	1	0
                     * The following $seqlane_progress (not "s") is generated to display progress bar
                     *  <summary>    all_sum completed_sum   inprogress_sum  onhold_sum
                     *  (summary)   3	2	1	0
                     * !!Status 'Completed' has priority more than 'In Progress' and 'On Hold'. (Completed > In Progress > On Hold)
                     */
                    $seqlane_progress = (object)array(
                        'all_sum' => (int)0,
                        'completed_sum' => (int)0,
                        'inprogress_sum' => (int)0,
                        'onhold_sum' => (int)0
                    );
                    $seqlane_progress->all_sum = count($seqlanes_progress);
                    foreach ($seqlanes_progress as $progress) {
                        if (isset($progress->completed_sum) and $progress->completed_sum > 0) {
                            $seqlane_progress->completed_sum++;
                        } else if (isset($progress->inprogress_sum) and $progress->inprogress_sum > 0) {
                            $seqlane_progress->inprogress_sum++;
                        } else if (isset($progress->onhold_sum) and $progress->onhold_sum > 0) {
                            $seqlane_progress->onhold_sum++;
                        }
                    }
                    $this->view->setVar('seqlane_progress', $seqlane_progress);
                }
            }
        }
    }

    public function operationAction()
    {
        Tag::appendTitle(' | Summary By Operation');
    }

    public function instrumentAction($instrument_id = null)
    {
        $this->view->cleanTemplateAfter()->setLayout('main');
        Tag::appendTitle(' | Summary By Instrument');


        $this->assets
            ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
            ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
            ->addJs('js/DataTables/extensions/Buttons/js/dataTables.buttons.min.js')
            ->addJs('js/DataTables/extensions/Buttons/js/buttons.bootstrap.min.js')
            ->addJs('js/DataTables/extensions/Buttons/js/buttons.html5.min.js')
            ->addJs('js/jszip/dist/jszip.min.js')
            ->addCss('js/DataTables/media/css/dataTables.bootstrap.css')
            ->addCss('js/DataTables/extensions/Buttons/css/buttons.bootstrap.min.css');

        /*
         * Get Instrument list
         */
        $instruments = Instruments::find(array(
                "active = 'Y'",
                "order" => "instrument_number ASC"
            )
        );
        $this->view->setVar('instruments', $instruments);

        $instrument_id = $this->filter->sanitize($instrument_id, array('int'));

        if(empty($instrument_id)){
            $instrument_id = $instruments->getFirst()->id;
        }
        $this->view->setVar('instrument_id', $instrument_id);

        $flowcells = $this->modelsManager->createBuilder()
            ->columns(array('fc.*', 'i.*', 'srmt.*', 'srrt.*', 'srct.*'))
            ->addFrom('Flowcells', 'fc')
            ->leftJoin('Instruments', 'i.id = fc.instrument_id', 'i')
            ->leftJoin('SeqRunTypeSchemes', 'srts.id = fc.seq_run_type_scheme_id', 'srts')
            ->leftJoin('SeqRunmodeTypes', 'srmt.id = srts.seq_runmode_type_id', 'srmt')
            ->leftJoin('SeqRunreadTypes', 'srrt.id = srts.seq_runread_type_id', 'srrt')
            ->leftJoin('SeqRuncycleTypes', 'srct.id = srts.seq_runcycle_type_id', 'srct')
            ->where('i.id = :instrument_id:', array("instrument_id" => $instrument_id))
            ->orderBy(array('fc.run_started_date DESC', 'fc.side ASC'))
            ->getQuery()
            ->execute();
        $this->view->setVar('flowcells', $flowcells);

    }

    public function overallAction($year = null, $month = null)
    {
        $this->view->cleanTemplateAfter()->setLayout('main');
        Tag::appendTitle(' | Overall');

        $this->assets
            ->addJs('js/DataTables/media/js/jquery.dataTables.min.js')
            ->addJs('js/DataTables/media/js/dataTables.bootstrap.js')
            ->addJs('js/DataTables/extensions/Buttons/js/dataTables.buttons.min.js')
            ->addJs('js/DataTables/extensions/Buttons/js/buttons.bootstrap.min.js')
            ->addJs('js/DataTables/extensions/Buttons/js/buttons.html5.min.js')
            ->addJs('js/jszip/dist/jszip.min.js')
            ->addCss('js/DataTables/media/css/dataTables.bootstrap.css')
            ->addCss('js/DataTables/extensions/Buttons/css/buttons.bootstrap.min.css');

        $year = $this->filter->sanitize($year, array("int"));
        $month = $this->filter->sanitize($month, array("int"));

        /*
         * Get Year-Month of run_started_date for button toolbar
         */
        $run_year_months = $this->modelsManager->createBuilder()
            ->columns(array(
                "YEAR(run_started_date) AS run_year",
                "MONTH(run_started_date) AS run_month"
            ))
            ->from('Flowcells')
            ->groupBy(array('run_year', 'run_month'))
            ->orderBy(array('run_year', 'run_month'))
            ->getQuery()
            ->execute();

        //Re-construct array with all month (1..12)
        $run_year_month_array = (object)[];
        $current_year_month = (object)[];
        foreach ($run_year_months as $run_year_month) {
            $run_year = (int)$run_year_month->run_year;
            $run_month = (int)$run_year_month->run_month;
            if (!isset($run_year_month_array->$run_year)) {
                $run_year_month_array->$run_year = (object)[];
            }

            //If the year-month of run_started_date is available then $run_year_month_array->$run_year->$run_month is 1 either 0.
            foreach (range(1, 12) as $month_chk) {
                if ($month_chk === $run_month) {
                    $run_year_month_array->$run_year->$month_chk = 1;
                    $current_year_month->year = $run_year;
                    $current_year_month->month = $run_month;
                } else if (!isset($run_year_month_array->$run_year->$month_chk)) {
                    $run_year_month_array->$run_year->$month_chk = 0;
                }
            }

            //If the year-month of run_started_date is indicated by $year and $month of URL then 2. (It is used for "class='btn active'"
            if ($run_year == $year and $run_month == $month) {
                $run_year_month_array->$run_year->$run_month = 2;
            }


        }
        /*
         * Redirect to current year/month record if $year or $month is null.
         */
        if (!isset($year) or !isset($month)) {
            return $this->response->redirect("summary/overall/" . $current_year_month->year . "/" . $current_year_month->month);
        }

        $this->view->setVar('run_year_month_array', $run_year_month_array);

        /*
         * Get data to display table withusing $year and $month
         */
        $overall_tmp = $this->modelsManager->createBuilder()
            ->columns(array('slane.*', 'sl.*', 'sta.*', 'fc.*', 'it.*', 'srmt.*', 'srrt.*', 'srct.*', 'sdr.*'))
            ->addFrom('Seqlanes', 'slane')
            ->join('SeqtemplateAssocs', 'sta.seqtemplate_id = slane.seqtemplate_id', 'sta')
            ->join('Seqlibs', 'sl.id = sta.seqlib_id', 'sl')
            ->leftJoin('Flowcells', 'fc.id = slane.flowcell_id', 'fc')
            ->leftJoin('SeqRunTypeSchemes', 'srts.id = fc.seq_run_type_scheme_id', 'srts')
            ->leftJoin('InstrumentTypes', 'it.id = srts.instrument_type_id', 'it')
            ->leftJoin('SeqRunmodeTypes', 'srmt.id = srts.seq_runmode_type_id', 'srmt')
            ->leftJoin('SeqRunreadTypes', 'srrt.id = srts.seq_runread_type_id', 'srrt')
            ->leftJoin('SeqRuncycleTypes', 'srct.id = srts.seq_runcycle_type_id', 'srct')
            ->leftJoin('SeqDemultiplexResults', 'sdr.seqlib_id = sl.id AND sdr.seqlane_id = slane.id', 'sdr');

        if (!empty($year) and $year > 0) {
            $overall_tmp = $overall_tmp->where("YEAR(fc.run_started_date) = :year:", array("year" => $year));
        }
        if (!empty($month) and $month > 0) {
            $overall_tmp = $overall_tmp->andWhere("MONTH(fc.run_started_date) = :month:", array("month" => $month));
        }
        $overall = $overall_tmp->orderBy(array('fc.run_started_date', 'fc.run_number', 'slane.number', 'sl.oligobarcodeA_id', 'sl.oligobarcodeB_id'))
            ->getQuery()
            ->execute();
        $this->view->setVar('overall', $overall);

    }

}
