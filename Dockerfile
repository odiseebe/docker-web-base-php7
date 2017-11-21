FROM centos:centos7.4.1708
MAINTAINER Kim Van Melckebeke <kim.vanmelckebeke@odisee.be>

# Install varioius utilities
RUN yum -y install wget epel-release

# Install Apache
RUN yum -y install httpd

# Install Remi Updated PHP 7
RUN wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
&& rpm -Uvh remi-release-7.rpm \
&& yum-config-manager --enable remi-php70 \
&& yum -y install php php-devel php-gd php-pdo php-soap php-xmlrpc php-xml php-phpunit-PHPUnit php-mysql

# Disable default apache welcome page
ADD welcome.conf /etc/httpd/conf.d/welcome.conf

# Override apache config
ADD httpd.conf /etc/httpd/conf/httpd.conf

# ADD phpinfo.php as default welcome page
ADD phpinfo.php /var/www/html/index.php

# Add mapping for apache document root
VOLUME [ "/var/www/html" ]

# UTC Timezone & Networking
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
&& echo "NETWORKING=yes" > /etc/sysconfig/network

#COPY supervisord.conf /etc/supervisord.conf
EXPOSE 80
CMD /usr/sbin/httpd -DFOREGROUND