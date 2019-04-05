#!/bin/bash

MEDIC_DB_NAME=$1 # URL to medic database couch-url
NODENAME=$2 # nodename e.g. couchdb@nodename <- [nodename] is the value for this
COUCHDB_USER=$3 # username for couchdb root user
COUCHDB_PASSWORD=$4 # password for couchdb root password

# write .env if it does not exist
if [ ! -f ./.env ]; then

  echo "COUCH_URL=http://$COUCHDB_USER:$COUCHDB_PASSWORD@couchdb:$5/$MEDIC_DB_NAME" >> .env
  echo "COUCH_NODE_NAME=couchdb@$NODENAME" >> .env
  echo "COUCH_USER=$COUCHDB_USER" >> .env
  echo "COUCH_PASSWORD=$COUCHDB_PASSWORD" >> .env

fi

# write .couch if it does not exist
if [ ! -f ./.couch ]; then

  echo "NODENAME=$NODENAME" >> .couch
  echo "COUCHDB_USER=$COUCHDB_USER" >> .couch
  echo "COUCHDB_PASSWORD=$COUCHDB_PASSWORD" >> .couch

fi

# export variables to Shell so as to be able to boot the system
export COUCH_URL="$MEDIC_DB_URL"
export COUCH_NODE_NAME="couchdb@$NODENAME"
export COUCH_USER="$COUCHDB_USER"
export COUCH_PASSWORD="$COUCHDB_PASSWORD"
export COUCH_PORT="$5"
