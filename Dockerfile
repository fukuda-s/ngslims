FROM centos:7

MAINTAINER Shiro FUKUDA

WORKDIR /root

RUN yum -y update
#git
RUN yum install -y git

#epel
RUN yum -y install epel-release
#remi
RUN yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm


#phpもろもろ
RUN \
    yum -y install --enablerepo=remi-php73 \
        php \
        php-devel \
        php-pear \
        php-mysqlnd \
        php-mbstring \
        php-fpm \
        php-phalcon3

RUN mkdir -p /var/run/php-fpm/

#nginxリポジトリ追加
RUN rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm && \
#nginxインストール
yum install nginx -y

RUN chown -R nginx:nginx /var/lib/php/session

#php.ini変更
##date.timezone = "Asia/Tokyo"←タイムゾーンの設定※行頭のコメントアウト;を外して、"Asia/Tokyo"と記述
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ \"Asia\/Tokyo\"/g' /etc/php.ini
##mbstring.language = Japanese←デフォルト言語の設定※行頭のコメントアウト;を外す
RUN sed -i 's/\;mbstring\.language\ \=\ Japanese/mbstring\.language\ \=\ Japanese/g' /etc/php.ini

#www.conf変更
##nginxに変更
RUN sed -i 's/user\ \=\ apache/user\ \=\ nginx/g' /etc/php-fpm.d/www.conf
RUN sed -i 's/group\ \=\ apache/group\ \=\ nginx/g' /etc/php-fpm.d/www.conf
##ソケット
RUN sed -i 's/\;listen\.owner\ \=\ nobody/listen\.owner\ \=\ nginx/g' /etc/php-fpm.d/www.conf
RUN sed -i 's/\;listen\.group\ \=\ nobody/listen\.group\ \=\ nginx/g' /etc/php-fpm.d/www.conf

#supervisorインストール
RUN yum install -y supervisor

COPY build/supervisord.conf /etc/supervisord.conf
COPY build/nginx.conf /etc/nginx/nginx.conf
COPY build/ngslims_server.conf /etc/nginx/conf.d/ngslims_server.conf
RUN /bin/mv -f /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.org

#ADD . /var/www/html/ngsLIMS
#COPY build/config_docker.ini /var/www/html/ngsLIMS/app/config/config.ini

RUN yum clean all
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
