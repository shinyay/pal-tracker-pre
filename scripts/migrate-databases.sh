#!/usr/bin/env bash
set -e

sudo apt-get install jq

app_guid=`cf app $1 --guid`

cf curl /v2/apps/${app_guid}/env

credentials=`cf curl /v2/apps/$app_guid/env | jq '.system_env_json.VCAP_SERVICES | .[] | .[] | select(.instance_name=="tracker-database") | .credentials'`

ip_address=`echo $credentials | jq -r '.hostname'`
db_name=`echo $credentials | jq -r '.name'`
db_username=`echo $credentials | jq -r '.username'`
db_password=`echo $credentials | jq -r '.password'`

echo "app_guid: ${app_guid}"
echo "credentials: ${credentials}"
echo "ip_address: ${ip_address}"
echo "db_name: ${db_name}"
echo "db_username: ${db_username}"
echo "db_password: ${db_password}"

echo "Opening ssh tunnel to $ip_address"
cf ssh -N -L 63306:$ip_address:3306 pal-tracker-syanagihara &
cf_ssh_pid=$!

echo "Waiting for tunnel"
sleep 5

flyway-*/flyway -url="jdbc:mysql://127.0.0.1:63306/$db_name" -locations=filesystem:$2/databases/tracker -user=$db_username -password=$db_password migrate

kill -STOP $cf_ssh_pid
