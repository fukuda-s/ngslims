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

1. Confirm installed PHP and php-fpm.
1. Confirm installed phalcon.so. Please refer [Phalcon document](https://docs.phalconphp.com/en/3.2/installation)
1. Confirm installed MySQL.
1. Confirm installed Nginx or Apache.
1. Copy 'ngslims' (downloaded) directory to your html document directory (ex. /var/www/html)
1. Config nginx. (You will be able to use 'ngslims/schemes/nginx_deault.conf' as /etc/nginx/conf.d/deault.conf.)
1. Import basic information into ngslims database on MySQL. (ex. mysql -uroot -p ngslims < ngslims/schemes/ngslims.sql) 
1. Access to 'http://localhost/ngslims' with web browser. Then you will be able to login with 'admin' user.


