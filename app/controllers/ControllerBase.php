<?php

class ControllerBase extends Phalcon\Mvc\Controller
{

    protected function initialize()
    {
        Phalcon\Tag::prependTitle('ngsLIMS | ');
    }

    protected function forward($uri)
    {
        $uriParts = explode('/', $uri);
        if (count($uriParts) > 1) {
            return $this->dispatcher->forward(
                array(
                    'controller' => $uriParts[0],
                    'action' => $uriParts[1]
                )
            );
        } else {
            return $this->dispatcher->forward(
                array(
                    'controller' => 'index',
                    'action' => $uriParts[0]
                )
            );
        }
    }
}
