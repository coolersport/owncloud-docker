FROM ubuntu:16.10

MAINTAINER hey@morrisjobke.de

ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_PID_FILE=/var/run/apache2/apache2.pid \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_RUN_DIR=/var/run/apache2 \
    TZ=Australia/Melbourne

COPY webdav /

RUN apt-get update && \
    apt-get install -y apache2 apache2-utils tzdata && \
    a2enmod dav dav_fs && \
    a2dissite 000-default && \
    mkdir -p $APACHE_LOG_DIR && \
    mkdir -p $APACHE_LOCK_DIR && \
    mkdir -p $APACHE_RUN_DIR && \
    mkdir -p /var/webdav; chown www-data /var/webdav && \
    mv /webdav.conf /etc/apache2/sites-available/ && \
    a2ensite webdav && \
    chown -R www-data $APACHE_LOG_DIR $APACHE_LOCK_DIR $APACHE_RUN_DIR && \
    chmod +x /run.sh

EXPOSE 8080

VOLUME /var/webdav

CMD ["/run.sh"]
