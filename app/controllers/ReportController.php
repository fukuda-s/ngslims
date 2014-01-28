<?php
use Phalcon\Tag, Phalcon\Acl;

class ReportController extends ControllerBase
{

    public function initialize()
    {
        $this->view->setTemplateAfter('main');
        Tag::setTitle('Report');
        parent::initialize();
    }

    public function indexAction()
    {
        // return $this->forward("trackerProjects/piList");
    }
}
