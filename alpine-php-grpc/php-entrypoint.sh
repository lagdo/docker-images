#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php "$@"
fi

# Install Composer packages
/usr/local/bin/php-command.sh

exec "$@"
