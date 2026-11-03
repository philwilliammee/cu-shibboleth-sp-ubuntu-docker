#!/bin/bash
# Start Shibboleth dont use `service shibd status`
/etc/init.d/shibd start
# Start Apache
/usr/local/bin/apache2-foreground
