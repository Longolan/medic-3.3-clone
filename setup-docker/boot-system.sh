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
  -d '{ "_id": "org.couchdb.user:admin", "name": "'$COUCH_USER'", "'$COUCH_PASSWORD'":"admin1234", "type":"user", "roles":[] }'

curl -X PUT http://$COUCH_USER:$COUCH_PASSWORD@127.0.0.1:$COUCH_PORT/_node/$COUCH_NODE_NAME/_config/httpd/secure_rewrites \
  -d '"false"' -H "Content-Type: application/json"

# sleep 10

echo 'Installing dependencies...'

cd webapp && npm install && cd ..
cd admin && npm install && cd ..
cd api && npm install && cd ..
cd sentinel && npm install && cd ..

echo 'Building webapp...'

grunt build

docker-compose up -d webapp
