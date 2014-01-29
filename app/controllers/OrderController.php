<?php
use Phalcon\Tag, Phalcon\Acl;

class OrderController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateAfter('main');
        Tag::setTitle('New Experiment Order');
        parent::initialize();
    }

    public function indexAction()
    {
        return $this->forward("order/newOrder");
    }

    public function newOrderAction()
    {
        $this->view->setVar('labs', Labs::find("active = 'Y'"));
        $this->view->setVar('sampletypes', SampleTypes::find(array(
            "active = 'Y'",
            "order" => "sort_order IS NULL ASC, sort_order ASC"
        )));
        $this->view->setVar('organisms', Organisms::find(array(
            "active = 'Y'",
            "order" => "sort_order IS NULL ASC, sort_order ASC"
        )));
        //$auth = $this->session->get('auth');
    }

    public function userSelectListAction($lab_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $lab_id = $this->filter->sanitize($lab_id, array(
                    "int"
                ));
                //Get auth to find current user.
                $auth = $this->session->get('auth');

                $phql = "
                    SELECT
                      u.id,
                      u.name
                    FROM
                      Users u, LabUsers lu
                    WHERE
                      u.id = lu.user_id
                    AND
                      lu.lab_id = :lab_id:
                    AND
                      lu.user_id != :user_id:
                    AND u.active = 'Y'
                    ORDER BY u.name";

                $users = $this->modelsManager->executeQuery($phql, array(
                    'lab_id' => $lab_id,
                    'user_id' => $auth['id'],
                ));

                $userList = array();
                $userList[$auth['id']] = $auth['name']; //Add current user_id, user_name on first row on select tab.
                foreach ($users as $user) {
                    $userList[$user->id] = $user->name;
                }

                echo '<label for="pi_user_id">PI </label>';
                echo $this->tag->selectStatic(
                    array(
                        "pi_user_id",
                        $userList,
                        'class' => 'form-control input-sm'
                    )
                );

            }
        }
    }

    public function projectSelectListAction($pi_user_id)
    {
        $this->view->disable();
        $request = new \Phalcon\Http\Request();
        // Check whether the request was made with method POST
        if ($request->isPost() == true) {
            // Check whether the request was made with Ajax
            if ($request->isAjax() == true) {
                $pi_user_id = $this->filter->sanitize($pi_user_id, array(
                    "int"
                ));

                $projects = Projects::find(array(
                    "pi_user_id = :pi_user_id:",
                    'bind' => array(
                        'pi_user_id' => $pi_user_id
                    )
                ));

                if ($projects) {
                    $projectList = array();
                    foreach ($projects as $project) {
                        $projectList[$project->id] = $project->name;
                    }

                    echo '<label for="project_id">Project </label>';
                    echo $this->tag->selectStatic(
                        array(
                            "project_id",
                            $projectList,
                            'useEmpty' => true,
                            'emptyText' => 'Please, choose Project...',
                            'emptyValue' => '@',
                            'class' => 'form-control input-sm'
                        )
                    );
                }

            }
        }
    }
}
