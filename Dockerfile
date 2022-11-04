FROM php:7.4-apache
COPY . /var/www/html/
WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive

# Set the timezone
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf


# ------------------------------- LDAP -----------------------------------------
RUN apt-get update && apt-get install -y \
    libldap-common \
    libldap2-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap

# ------------------------------- Shib -----------------------------------------
RUN apt-get update && apt-get install -y \
    libapache2-mod-shib
RUN a2enmod rewrite

COPY ./docker/etc/apache2/conf-enabled/shib.conf /etc/apache2/conf-enabled/shib.conf
COPY ./docker/etc/shibboleth/*.pem /etc/shibboleth/
COPY ./docker/etc/shibboleth/*.xml /etc/shibboleth/

# ------------------------ Oracle instantclient --------------------------------
RUN apt-get update && apt-get install -y \
    unzip \
    libaio1

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

RUN docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient \
    && docker-php-ext-install oci8

RUN echo /usr/local/instantclient/ > /etc/ld.so.conf.d/oracle-insantclient.conf \
    && ldconfig

# --------------------------- HTTPS Support ------------------------------------
# Uncomment to generate certs
# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=US/ST=New_York/L=Ithaca/O=Cornell/OU=SSIT/CN=localhost"
COPY ./docker/etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/private/ssl-cert-snakeoil.key
COPY ./docker/etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/certs/ssl-cert-snakeoil.pem
RUN a2enmod ssl
RUN a2ensite default-ssl.conf

EXPOSE 80 443

COPY ./docker/scripts/start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]
