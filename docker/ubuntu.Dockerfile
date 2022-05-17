FROM ubuntu:20.04
COPY . /var/www/html/
WORKDIR /var/www/html

ENV TZ=America/New_York
ENV DEBIAN_FRONTEND noninteractive

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    apache2 \
    apache2-utils \
    php \
    php-common \
    libapache2-mod-php \
    libapache2-mod-shib2

RUN echo 'ServerName $HOSTNAME' >> /etc/apache2/apache2.conf

# Set the shibb authentication module
COPY ./docker/etc/apache2/conf-enabled/shib.conf /etc/apache2/conf-enabled/shib.conf

# HTTPS Support
RUN a2enmod ssl
RUN a2ensite default-ssl.conf
# Uncomment to generate certs
# RUN mkdir /etc/apache2/ssl
# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -subj "/C=US/ST=New_York/L=Ithaca/O=Cornell/OU=SSIT/CN=$HOSTNAME"

# Enable modules
RUN a2enmod auth_basic
RUN a2enmod shib
RUN a2enmod rewrite

# Copy cert files to the container
COPY ./docker/etc/shibboleth/*.pem /etc/shibboleth/
COPY ./docker/etc/shibboleth/*.xml /etc/shibboleth/

# Add file permissions
# RUN LD_LIBRARY_PATH=/opt/shibboleth/lib64 /sbin/shibd -t 
# RUN service shibd start 
# RUN chown -R _shibd:_shibd /var/log/shibboleth/*.log
# it may also be required to chown _shibd sp-*.pem

EXPOSE 80 443

COPY ./docker/scripts/start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]



