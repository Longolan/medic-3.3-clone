#!/bin/bash

echo 'Starting couchdb...'

docker-compose up -d couchdb

sleep 20

echo 'Securing couchdb...'

echo "http://$COUCH_USER:$COUCH_PASSWORD@127.0.0.1:$COUCH_PORT/_global_changes"

curl -X PUT http://$COUCH_USER:$COUCH_PASSWORD@127.0.0.1:$COUCH_PORT/_users
curl -X PUT http://$COUCH_USER:$COUCH_PASSWORD@127.0.0.1:$COUCH_PORT/_replicator
curl -X PUT http://$COUCH_USER:$COUCH_PASSWORD@127.0.0.1:$COUCH_PORT/_global_changes

curl -X POST http://$COUCH_USER:$COUCH_PASSWORD@127.0.0.1:$COUCH_PORT/_users \
  -H "Content-Type: application/json" \
  -d '{ "_id": "org.couchdb.user:admin", "name": "'$COUCH_USER'", "password":"'$COUCH_PASSWORD'", "type":"user", "roles":[] }'

curl -X PUT http://$COUCH_USER:$COUCH_PASSWORD@127.0.0.1:$COUCH_PORT/_node/$COUCH_NODE_NAME/_config/httpd/secure_rewrites \
  -d '"false"' -H "Content-Type: application/json"

# sleep 10

docker-compose up --build -d webapp
