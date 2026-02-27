#!/bin/sh
set -e

# Install Composer packages
/usr/local/bin/php-command.sh

if [ "${RR_CONFIG_FILE}" == "" ]
then
    RR_CONFIG_FILE=/var/www/rr.yaml
fi

/usr/local/bin/rr serve -c ${RR_CONFIG_FILE}
