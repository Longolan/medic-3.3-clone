#!/bin/bash

echo http://admin:admin1234@127.0.0.1:5984/_global_changes

curl -X PUT http://admin:admin1234@127.0.0.1:5984/_users
curl -X PUT http://admin:admin1234@127.0.0.1:5984/_replicator
curl -X PUT http://admin:admin1234@127.0.0.1:5984/_global_changes

curl -X POST http://admin:admin1234@127.0.0.1:5984/_users \
  -H "Content-Type: application/json" \
  -d '{ "_id": "org.couchdb.user:admin", "name": "admin", "password":"admin1234", "type":"user", "roles":[] }'

curl -X PUT http://admin:admin1234@127.0.0.1:5984/_node/couchdb@couchdb-image/_config/httpd/secure_rewrites \
  -d '"false"' -H "Content-Type: application/json"
