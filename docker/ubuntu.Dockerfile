FROM php:7.4-apache
COPY . /var/www/html/
WORKDIR /var/www/html

ENV TZ=America/New_York
ENV DEBIAN_FRONTEND noninteractive

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    libapache2-mod-shib

RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf

# ------------------- Set the shibb authentication module ----------------------
COPY ./docker/etc/apache2/conf-enabled/shib.conf /etc/apache2/conf-enabled/shib.conf
# Enable modules
RUN a2enmod auth_basic
RUN a2enmod rewrite
RUN a2enmod shib
# Copy cert files to the container
COPY ./docker/etc/shibboleth/*.pem /etc/shibboleth/
COPY ./docker/etc/shibboleth/*.xml /etc/shibboleth/

# --------------------------- HTTPS Support ------------------------------------
RUN a2enmod ssl
RUN a2ensite default-ssl.conf
# Uncomment to generate certs
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=US/ST=New_York/L=Ithaca/O=Cornell/OU=SSIT/CN=localhost"

EXPOSE 80 443

COPY ./docker/scripts/start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]



