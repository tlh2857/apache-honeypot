FROM ubuntu:20.04

MAINTAINER lopqto <morpix@protonmail.com>

# Install the required packages
RUN apt-get update  && apt-get install -y \
    build-essential zlibc libapr1-dev \
    libaprutil1-dev libpcre3-dev zlib1g zlib1g-dev wget \
    subversion python3 autoconf libtool-bin

WORKDIR /honeypot

# Download the vulnerable version
RUN wget https://github.com/apache/httpd/archive/refs/tags/2.4.49.tar.gz \
    && tar -xvf 2.4.49.tar.gz

WORKDIR /honeypot/httpd-2.4.49/

# Compile the vulenrable version
RUN svn co http://svn.apache.org/repos/asf/apr/apr/trunk srclib/apr \
    && ./buildconf \
    && ./configure --prefix=/usr/local/apache2 \
    --enable-mods-shared=all --enable-deflate --enable-proxy \
    --enable-proxy-balancer --enable-proxy-http \
    && make && make install

RUN mkdir -p /var/www/html && mkdir /var/log/apache2/

# Update the required permissions for www-data
RUN chown -hR www-data:www-data /var/www/html \
    && chown -hR www-data:www-data /var/log/apache2/ \
    && chown -hR www-data:www-data /usr/local/apache2/logs/

USER www-data

WORKDIR /var/www/html

# Run apache in foreground mode
ENTRYPOINT ["/usr/local/apache2/bin/apachectl", "-D", "FOREGROUND"]
