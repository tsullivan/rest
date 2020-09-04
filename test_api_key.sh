#!/bin/bash
set -x

ES_URL=https://localhost:9200
BASIC_AUTH_HEADER=ZWxhc3RpYzpjaGFuZ2VtZQ==

KEY_FROM_BASIC_AUTH=$(curl -s -X POST ${ES_URL}/_security/api_key \
    -H 'Content-Type: application/json' \
    -H "Authorization: Basic ${BASIC_AUTH_HEADER}" \
    -d '{ "name": "tim-is-awesome", "expiration": "10m" }')

API_KEY=$(echo $KEY_FROM_BASIC_AUTH | jq -j '.id + ":" + .api_key' | base64)

curl -s -X GET ${ES_URL}/_security/user/_has_privileges \
    -H 'Content-Type: application/json' \
    -H "Authorization: ApiKey ${API_KEY}" \
    -d '{ "cluster": [ "manage_own_api_key", "manage_api_key", "monitor" ], "index": [ { "names": ["*"], "privileges": [ "read", "write" ] } ] }' | jq


