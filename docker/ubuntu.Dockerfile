FROM php:7.4-apache
COPY . /var/www/html/
WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive

# Set the timezone
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf

# ---------------------------- Install packages --------------------------------
RUN apt-get update && apt-get install -y \
    libapache2-mod-shib

# --------------------------- Configure services -------------------------------
RUN a2enmod rewrite
# enable https
RUN a2enmod ssl
RUN a2ensite default-ssl.conf

# --------------------------- Shibb configuration ------------------------------
COPY ./docker/etc/apache2/conf-enabled/shib.conf /etc/apache2/conf-enabled/shib.conf
# Copy cert files to the container
COPY ./docker/etc/shibboleth/*.pem /etc/shibboleth/
COPY ./docker/etc/shibboleth/*.xml /etc/shibboleth/

# --------------------------- HTTPS Support ------------------------------------
# Uncomment to generate certs
# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=US/ST=New_York/L=Ithaca/O=Cornell/OU=SSIT/CN=localhost"
COPY ./docker/etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/private/ssl-cert-snakeoil.key
COPY ./docker/etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/certs/ssl-cert-snakeoil.pem

EXPOSE 80 443

COPY ./docker/scripts/start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]
