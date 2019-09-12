ngsLIMS
================

ngsLIMS manage samples, libraries and sequence runs for NGS (Next Generation Sequencer).

Get Started
-----------

#### Requirements

To run this application on your machine, you need at least:

* PHP (>=5.3.9)
* php-fpm
* mysql (>=5.6)
* nginx
* Latest Phalcon Framework extension installed/enabled

Install
-----------

#### Build via Docker
1. Confirm installed Git, Docker and docker-compose.
1. `git clone https://github.com/fukuda-s/ngslims.git`
1. `cd ngslims/`
1. `docker-compose up`

#### Build as native
1. Confirm installed PHP and php-fpm.
1. Confirm installed phalcon.so. Please refer [Phalcon document](https://docs.phalconphp.com/en/3.2/installation)
1. Confirm installed MySQL.
1. Confirm installed Nginx or Apache.
1. Copy 'ngslims' (downloaded) directory to your html document directory (ex. /var/www/html)
1. Config nginx.
    1. Use 'ngslims/build/nginx.conf' as /etc/nginx/nginx.conf.
    1. You will be able to use 'ngslims/build/nginx_server.conf' as /etc/nginx/conf.d/deault.conf.
1. Import basic information into ngslims database on MySQL. (ex. mysql -uroot -p ngslims < ngslims/schemes/ngslims.sql) 
1. Access to 'http://localhost/ngslims' with web browser. Then you will be able to login with 'admin' user.

Demo
-----------
https://youtu.be/VaezN9AbWIg
