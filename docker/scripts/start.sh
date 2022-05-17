#!/bin/bash
# Start Shibboleth dont use `service shibd status`
/etc/init.d/shibd start
# Start Apache
apache2ctl -D FOREGROUND