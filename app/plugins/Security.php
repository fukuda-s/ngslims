<?php
use Phalcon\Events\Event, Phalcon\Mvc\User\Plugin, Phalcon\Mvc\Dispatcher, Phalcon\Acl;

/**
 * Security
 *
 * This is the security plugin which controls that users only have access to the modules they're assigned to
 */
class Security extends Plugin
{

    public function __construct($dependencyInjector)
    {
        $this->_dependencyInjector = $dependencyInjector;
    }

    public function getAcl()
    {
        if (!isset($this->persistent->acl)) {

            $acl = new Phalcon\Acl\Adapter\Memory();

            $acl->setDefaultAction(Phalcon\Acl::DENY);

            // Register roles
            $roles = array(
                // 'admin' => new Phalcon\Acl\Role('Admins'),
                'users' => new Phalcon\Acl\Role('Users'),
                'guests' => new Phalcon\Acl\Role('Guests')
            );
            foreach ($roles as $role) {
                $acl->addRole($role);
            }

            // Private area resources
            $privateResources = array(
                'order' => array(
                    'index',
                    'newOrder',
                    'userSelectList',
                    'projectSelectList',
                    'stepSelectList',
                    'protocolSelectList',
                    'instrumentTypeSelectList',
                    'seqRunmodeTypesSelectList',
                    'seqRunreadTypesSelectList',
                    'seqRuncycleTypesSelectList',
                    'orderSetSession',
                    'loadSessionSampleData',
                    'saveProject',
                    'confirm',
                    'checkout',
                    'removeOrderSession'
                ),
                'summary' => array(
                    'index',
                    'projectPi',
                    'projectName',
                    'projectNameProgress',
                    'operation',
                    'overall'
                ),
                'tracker' => array(
                    'index',
                    'project',
                    'experiments',
                    'experimentDetails',
                    'multiplexCandidates',
                    'multiplexSetup',
                    'multiplexSetSession',
                    'multiplexSetupConfirm',
                    'multiplexSave',
                    'flowcellSetupCandidates',
                    'flowcellSetup',
                    'flowcellSetupSetSession',
                    'flowcellSetupConfirm',
                    'flowcellSetupSave',
                    'flowcell',
                    'sequence',
                    'sequenceSetupCandidates',
                    'sequenceSetupConfirm',
                    'sequenceSetupSave',
                    'protocol'
                ),
                'trackerdetails' => array(
                    'index',
                    'showTableSamples',
                    'showPanelSamples',
                    'showPanelSeqlibs',
                    'showTubeSeqlibs',
                    'showPanelSeqlanes',
                    'showTableSeqlibs',
                    'showTubeSeqtemplates',
                    'loadSamples',
                    'editSamples',
                    'saveSamples',
                    'editSeqlibs',
                    'saveSeqlibs',
                    'editSeqlanes',
                    'saveSeqlanes',
                    'getMaxRunNumber'
                ),
                'projects' => array(
                    'loadjson'
                ),
                'sampletypes' => array(
                    'loadjson'
                ),
                'samplelocations' => array(
                    'loadjson'
                ),
                'organisms' => array(
                    'loadjson'
                ),
                'oligobarcodes' => array(
                    'loadjson'
                ),
                'protocols' => array(
                    'loadjson'
                ),
                'samples' => array(
                    'loadjson'
                ),
                'seqlibs' => array(
                    'loadjson'
                ),
                'seqtemplates' => array(
                    'loadjson'
                ),
                'report' => array(
                    'index'
                ),
                'search' => array(
                    'index',
                    'result',
                    'showProjects',
                    'showSamples',
                    'showSeqlibs'
                )
            );
            foreach ($privateResources as $resource => $actions) {
                $acl->addResource(new Phalcon\Acl\Resource($resource), $actions);
            }

            // Public area resources
            $publicResources = array(
                'index' => array(
                    'index'
                ),
                'about' => array(
                    'index'
                ),
                'session' => array(
                    'index',
                    'register',
                    'start',
                    'end',
                    'account',
                    'password'
                ),
                'contact' => array(
                    'index',
                    'send'
                )
            );
            foreach ($publicResources as $resource => $actions) {
                $acl->addResource(new Phalcon\Acl\Resource($resource), $actions);
            }

            // Grant access to public areas to both users and guests
            foreach ($roles as $role) {
                foreach ($publicResources as $resource => $actions) {
                    $acl->allow($role->getName(), $resource, $actions);
                }
            }

            // Grant acess to private area to role Users
            foreach ($privateResources as $resource => $actions) {
                foreach ($actions as $action) {
                    $acl->allow('Users', $resource, $action);
                }
            }

            // The acl is stored in session, APC would be useful here too
            $this->persistent->acl = $acl;
        }

        return $this->persistent->acl;
    }

    /**
     * This action is executed before execute any action in the application
     */
    public function beforeDispatch(Event $event, Dispatcher $dispatcher)
    {
        $auth = $this->session->get('auth');
        if (!$auth) {
            $role = 'Guests';
        } else {
            $role = 'Users';
        }

        $controller = $dispatcher->getControllerName();
        $action = $dispatcher->getActionName();

        $acl = $this->getAcl();

        $allowed = $acl->isAllowed($role, $controller, $action);
        if ($allowed != Acl::ALLOW) {
            $this->flash->error("You don't have access to this module with : " . $allowed . ", " . $role . ", " . $controller . ", " . $action);
            $dispatcher->forward(array(
                'controller' => 'index',
                'action' => 'index'
            ));
            return false;
        }
    }
}
