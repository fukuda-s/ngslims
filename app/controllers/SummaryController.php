<?php
use Phalcon\Tag, Phalcon\Acl;


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

    public function operationAction() {
        Tag::appendTitle(' | Summary By Operation');
    }

}
