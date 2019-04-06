#!/bin/bash

set -ex

ICECAST_CONFIG_DIR=/etc/icecast2
ICECAST_CONFIG=$ICECAST_CONFIG_DIR/icecast.xml
LIQUIDSOAP_CONFIG_DIR=/home/docker
LIQUIDSOAP_CONFIG=$LIQUIDSOAP_CONFIG_DIR/liquidsoap.liq

N_CLIENTS=${N_CLIENTS:-250}
N_SOURCES=${N_SOURCES:-30}
QUEUE_SIZE=${QUEUE_SIZE:-5242880}
CLIENT_TIMEOUT=${CLIENT_TIMEOUT:-30}
HEADER_TIMEOUT=${HEADER_TIMEOUT:-20}
SOURCE_TIMEOUT=${SOURCE_TIMEOUT:-80}
BURST_ON_CONNECT=${BURST_ON_CONNECT:-1}
BURST_SIZE=${BURST_SIZE:-65535}
DEFAULT_PORT=${DEFAULT_PORT:-8000}

SOURCE_PASSWORD=${SOURCE_PASSWORD:-"source_password"}
RELAY_PASSWORD=${RELAY_PASSWORD:-"relay_password"}
ADMIN_USER=${ADMIN_USER:-"admin"}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-"admin_password"}

# Take control of config directories
sudo -E chown -R docker: $ICECAST_CONFIG_DIR
sudo -E chown -R docker: $LIQUIDSOAP_CONFIG_DIR

# Inject icecast config
sed -i -e "s/{N_CLIENTS}/${N_CLIENTS}/g" \
       -e "s/{N_SOURCES}/${N_SOURCES}/g" \
       -e "s/{QUEUE_SIZE}/${QUEUE_SIZE}/g" \
       -e "s/{CLIENT_TIMEOUT}/${CLIENT_TIMEOUT}/g" \
       -e "s/{HEADER_TIMEOUT}/${HEADER_TIMEOUT}/g" \
       -e "s/{SOURCE_TIMEOUT}/${SOURCE_TIMEOUT}/g" \
       -e "s/{BURST_ON_CONNECT}/${BURST_ON_CONNECT}/g" \
       -e "s/{BURST_SIZE}/${BURST_SIZE}/g" \
       -e "s/{DEFAULT_PORT}/${DEFAULT_PORT}/g" \
       -e "s/{SOURCE_PASSWORD}/${SOURCE_PASSWORD}/g" \
       -e "s/{RELAY_PASSWORD}/${RELAY_PASSWORD}/g" \
       -e "s/{ADMIN_USER}/${ADMIN_USER}/g" \
       -e "s/{ADMIN_PASSWORD}/${ADMIN_PASSWORD}/g" \
       $ICECAST_CONFIG

# Inject liquidsoap config
sed -i -e "s/{SOURCE_PASSWORD}/${SOURCE_PASSWORD}/g" \
       -e "s/{DEFAULT_PORT}/${DEFAULT_PORT}/g" \
       $LIQUIDSOAP_CONFIG

# Restore permissions.
sudo -E chown -R docker: /var/log/icecast2
sudo mkdir -p /var/log/liquidsoap
sudo chown -R docker: /var/log/liquidsoap

# Start services.
sudo -E -u docker icecast2 -c $ICECAST_CONFIG >/dev/null 2>&1 &
PID_ICECAST=$!

sudo -E -u docker opam config exec liquidsoap $LIQUIDSOAP_CONFIG --root=/home/docker/.opam >/dev/null 2>&1 &
PID_LIQUIDSOAP=$!

wait $PID_ICECAST $PID_LIQUIDSOAP

if [[ "$DEBUG" -eq "1" ]]; then
    # Hang so that the container stays live.
    tail -f /dev/null
fi
