#!/bin/sh

COMMAND=$1

if [ "${RUN_INSTALL}" == "true" ]
then
    if [ "${COMMAND_USER}" == "" ]
    then
        (cd ${COMMAND_DIR} && composer ${INSTALL_OPTIONS})
    else
        (cd ${COMMAND_DIR} && su ${COMMAND_USER} -c 'composer ${INSTALL_OPTIONS}')
    fi
fi

if [ "${RUN_CACHE_CLEAR}" == "true" ] && [ "${CACHE_CLEAR_COMMAND}" != "" ]
then
    if [ "${COMMAND_USER}" == "" ]
    then
        (cd ${COMMAND_DIR} && php ${CACHE_CLEAR_COMMAND})
    else
        (cd ${COMMAND_DIR} && su ${COMMAND_USER} -c 'php ${CACHE_CLEAR_COMMAND}')
    fi
fi
