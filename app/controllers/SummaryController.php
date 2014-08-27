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
                     *  (seqlib2)   1	1	1	0
                     *  (seqlib3)   1	1	1	0
                     * The following $seqlane_progress (not "s") is generated to display progress bar
                     *  <summary>    all_sum completed_sum   inprogress_sum  onhold_sum
                     *  (summary)   3	3	0	0
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
                        }
                        else if (isset($progress->inprogress_sum) and $progress->inprogress_sum > 0) {
                            $seqlane_progress->inprogress_sum++;
                        }
                        else if (isset($progress->onhold_sum) and $progress->onhold_sum > 0) {
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

}
