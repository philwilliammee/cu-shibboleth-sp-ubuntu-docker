FROM ubuntu:20.04
COPY . /var/www/html/
WORKDIR /var/www/html

ENV TZ=America/New_York
ENV DEBIAN_FRONTEND noninteractive
ENV LD_LIBRARY_PATH="/usr/local/instantclient"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    apache2 \
    apache2-utils \
    php \
    php-common \
    php-dev\
    php-pear \
    build-essential \
    libaio1 \
    libapache2-mod-php \
    libapache2-mod-shib2 \
    zip \
    unzip

RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf

# Set the shibb authentication module
COPY ./docker/etc/apache2/conf-enabled/shib.conf /etc/apache2/conf-enabled/shib.conf

# HTTPS Support
RUN a2enmod ssl
RUN a2ensite default-ssl.conf
# Uncomment to generate certs
# RUN mkdir /etc/apache2/ssl
# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -subj "/C=US/ST=New_York/L=Ithaca/O=Cornell/OU=SSIT/CN=localhost"

# Enable modules
RUN a2enmod auth_basic
RUN a2enmod shib
RUN a2enmod rewrite

# Copy cert files to the container
COPY ./docker/etc/shibboleth/*.pem /etc/shibboleth/
COPY ./docker/etc/shibboleth/*.xml /etc/shibboleth/

# Oracle instantclient

# copy oracle files
ADD https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip /tmp/
ADD https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sdk-linux.x64-21.1.0.0.0.zip /tmp/
ADD https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sqlplus-linux.x64-21.1.0.0.0.zip /tmp/

# unzip them
RUN unzip /tmp/instantclient-basic-linux.x64-*.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sdk-linux.x64-*.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sqlplus-linux.x64-*.zip -d /usr/local/

# install oci8
RUN ln -s /usr/local/instantclient_*_1 /usr/local/instantclient \
    && ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus

RUN pecl channel-update pecl.php.net
RUN echo 'instantclient,/usr/local/instantclient' | pecl install oci8-2.2.0

#enable php extension
RUN echo "extension=oci8.so" >> /etc/php/7.4/cli/php.ini
RUN echo "extension=oci8.so" >> /etc/php/7.4/apache2/php.ini

RUN echo /usr/local/instantclient/ > /etc/ld.so.conf.d/oracle-insantclient.conf \
    && ldconfig


EXPOSE 80 443

COPY ./docker/scripts/start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]



