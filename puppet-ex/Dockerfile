FROM ubuntu:12.04

MAINTAINER Ben Schwartz, https://github.com/benschw

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

RUN apt-get update


# install apache & php
RUN apt-get install -y apache2 php5

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

ADD ./httpdocs /var/www




# Launch apache when launching the container

ENTRYPOINT ["/usr/sbin/apache2"]
CMD ["-D", "FOREGROUND"]

