<?php
/**
 * (The MIT License)
 *
 * Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * 'Software'), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

//error_reporting(E_ALL ^ E_NOTICE);
error_reporting(E_ALL);


/**
 * Read the configuration
 */
$config = new Phalcon\Config\Adapter\Ini(__DIR__ . '/../app/config/config.ini');

$loader = new \Phalcon\Loader();

/**
 * We're a registering a set of directories taken from the configuration file
 */
$loader->registerDirs(
    array(
        __DIR__ . '/' . $config->application->controllersDir,
        __DIR__ . '/' . $config->application->pluginsDir,
        __DIR__ . '/' . $config->application->libraryDir,
        __DIR__ . '/' . $config->application->modelsDir,
    )
)->register();

/**
 * The FactoryDefault Dependency Injector automatically register the right services providing a full stack framework
 */
$di = new \Phalcon\DI\FactoryDefault();

/**
 * We register the events manager
 */
$di->set('dispatcher', function () use ($di) {

    $eventsManager = $di->getShared('eventsManager');

    $security = new Security($di);

    /**
     * We listen for events in the dispatcher using the Security plugin
     */
    $eventsManager->attach('dispatch', $security);

    $dispatcher = new Phalcon\Mvc\Dispatcher();
    $dispatcher->setEventsManager($eventsManager);

    return $dispatcher;
});

/**
 * The URL component is used to generate all kind of urls in the application
 */
$di->set('url', function () use ($config) {
    $url = new \Phalcon\Mvc\Url();
    $url->setBaseUri($config->application->baseUri);
    return $url;
});


$di->set('view', function () use ($config) {

    $view = new \Phalcon\Mvc\View();

    $view->setViewsDir(__DIR__ . '/' . $config->application->viewsDir);

    $view->registerEngines(array(
        ".volt" => 'volt'
    ));

    return $view;
});

/**
 * Setting up volt
 */
$di->set('volt', function ($view, $di) {

    $volt = new \Phalcon\Mvc\View\Engine\Volt($view, $di);

    $volt->setOptions(array(
        "compiledPath" => "../cache/volt/"
    ));

    $compiler = $volt->getCompiler();

    /*
     * Bind PHP function into VOLT.
     */
    $compiler->addFunction('strtotime', 'strtotime');
    $compiler->addFunction('number_format', 'number_format');
    $compiler->addFunction('round', 'round');

    return $volt;
}, true);

/**
 * Database connection is created based in the parameters defined in the configuration file
 */
$di->set('db', function () use ($config) {
    return new \Phalcon\Db\Adapter\Pdo\Mysql(array(
        "host" => $config->database->host,
        "username" => $config->database->username,
        "password" => $config->database->password,
        "dbname" => $config->database->name
    ));
});

/**
 * If the configuration specify the use of metadata adapter use it or use memory otherwise
 */
$di->set('modelsMetadata', function () use ($config) {
    if (isset($config->models->metadata)) {
        $metaDataConfig = $config->models->metadata;
        $metadataAdapter = 'Phalcon\Mvc\Model\Metadata\\' . $metaDataConfig->adapter;
        return new $metadataAdapter();
    }
    return new Phalcon\Mvc\Model\Metadata\Memory();
});

/**
 * Start the session the first time some component request the session service
 */
$di->set('session', function () {
    $session = new Phalcon\Session\Adapter\Files();
    $session->setOptions(array(
        'uniqueId' => 'ngslims'
    ));
    $session->start();
    return $session;
});

/**
 * Register the flash service with custom CSS classes
 */
$di->set('flash', function () {
    $flash = new \Phalcon\Flash\Direct(array(
        'success' => 'alert alert-success',
        'notice' => 'alert alert-info',
        'warning' => 'alert alert-warning',
        'error' => 'alert alert-danger'
    ));
    return $flash;
});

/**
 * Register the flash service with custom CSS classes
 */
$di->set('flashSession', function () {
    $flash = new Phalcon\Flash\Session(array(
        'success' => 'alert alert-success',
        'notice' => 'alert alert-info',
        'warning' => 'alert alert-warning',
        'error' => 'alert alert-danger'
    ));
    return $flash;
});

/**
 * Register a user component
 */
$di->set('elements', function () {
    return new Elements();
});

/**
 * Register custom user filter for sanitizing
 */
$di->set('filter', function () {
    $filter = new Phalcon\Filter();
    $filter->add('name_filter', function ($value) {
        $value = preg_replace('/[^a-zA-Z0-9\.\-_]/', '', $value);
        $value = preg_replace('/\.+/', '.', $value);
        $value = preg_replace('/\.+$/', '', $value);
        return $value;
    });
    return $filter;
});

$application = new \Phalcon\Mvc\Application($di);
try {
    $response = $application->handle();
    $response->send();
} catch (Phalcon\Exception $e) {
    echo $e->getMessage();
} catch (PDOException $e) {
    echo $e->getMessage();
}