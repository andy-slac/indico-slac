#!/usr/bin/env bash

CONFIG_FILES="$INDICO_DIR/data/etc/indico.conf $INDICO_DIR/data/etc/logging.yaml"

# generate configuration
if [ "$1" = "make-config" ]; then
    for f in $CONFIG_FILES; do
        if [ -f "$f" ]; then
            cat >&2 <<EOWARN
***************************************************************************
WARNING: Configuration files exist and will not be overwritten. Remove or
         rename files if you want it replaced with default configuration:
         $CONFIG_FILES
***************************************************************************
EOWARN
            exit 2
        fi
    done
    mkdir -p $INDICO_DIR/data/etc
    cp /home/indico/indico/etc/* $INDICO_DIR/data/etc/
    exit
fi

# setup indico
export INDICO_CONFIG=$INDICO_DIR/data/etc/indico.conf
. /home/${INDICO_USER}/indico-venv/bin/activate

# make folders if they don't exist yet
mkdir -p ${INDICO_DIR}/data/etc ${INDICO_DIR}/data/archive
mkdir -p ${INDICO_DIR}/scratch/log ${INDICO_DIR}/scratch/tmp ${INDICO_DIR}/scratch/cache

# for all other options we need config files
if [ "$1" = "run" ]; then
    for f in $CONFIG_FILES; do
        if [ ! -f "$f" ]; then
            cat >&2 <<EOWARN
***************************************************************************
WARNING: Configuration files are missing. Please run container with
         "make-config" argument and update configuration files.
         $CONFIG_FILES
***************************************************************************
EOWARN
            exit 2
        fi
    done
    exec /usr/bin/uwsgi --ini /etc/uwsgi.ini
else
    exec "$@"
fi