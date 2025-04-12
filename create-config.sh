#!/bin/bash

if [[ ! -f .env ]]; then echo ".env file not found!"; exit 1; fi

source .env

if [[ -z "$IPADDRESS_VIRTUAL" ]]; then echo "IPADDRESS_VIRTUAL is not set in the .env file!"; exit 1; fi
if [[ -z "$IPADDRESS_MASTER" ]]; then echo "IPADDRESS_MASTER is not set in the .env file!"; exit 1; fi
if [[ -z "$IPADDRESS_BACKUP" ]]; then echo "IPADDRESS_BACKUP is not set in the .env file!"; exit 1; fi
if [[ -z "$PASS" ]]; then echo "PASS is not set in the .env file!"; exit 1; fi

export PASS=$PASS
export IPADDRESS_VIRTUAL=$IPADDRESS_VIRTUAL

# render master server config
export STATE="MASTER"
export UNICAST_SRC_IP=$IPADDRESS_MASTER
export UNICAST_PEER=$IPADDRESS_BACKUP
export PRIORITY="100"
echo "# This file is auto-generated. Do not edit!" > keepalived_master.conf
envsubst < config.template >> keepalived_master.conf

# render backup server config
export STATE="BACKUP"
export UNICAST_SRC_IP=$IPADDRESS_BACKUP # note: that these are swapped!
export UNICAST_PEER=$IPADDRESS_MASTER # note: that these are swapped!
export PRIORITY="75"
echo "# This file is auto-generated. Do not edit!" > keepalived_backup.conf
envsubst < config.template >> keepalived_backup.conf