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
        $request = $this->request;

        $query = $request->get('q', 'striptags');
        if (empty($query)) {
            $this->flashSession->warning("Please input search words.");
            return $this->response->redirect("search/index");
        }
        $this->view->setVar('query', $query);
        $this->flash->success('Search by "' . $query . '"');

        //Set sample_property_types for columns of Handsontable.
        $phql = "
          SELECT
            spt.id,
            spt.name,
            spt.mo_term_name,
            COUNT(s.id) AS sample_count
          FROM
            SamplePropertyTypes spt
             LEFT JOIN
            SamplePropertyEntries spe ON spe.sample_property_type_id = spt.id
             LEFT JOIN
            Samples s ON s.id = spe.sample_id
               AND s.name LIKE :query:
            GROUP BY spt.id
        ";
        $sample_property_types = $this->modelsManager->executeQuery($phql, array(
            'query' => '%' . $query . '%'
        ));
        $this->view->setVar('sample_property_types', $sample_property_types);

    }

}
