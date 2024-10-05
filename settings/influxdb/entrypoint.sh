#!/bin/bash

influxd --reporting-disabled &

sleep 15

if [ ! -f "/shared/.initialized-influx" ]; then
  if influx setup --force=true --username="${INFLUXDB_USERNAME}" --password="${INFLUXDB_PASSWORD}" --org="${INFLUXDB_ORG}" --bucket="${INFLUXDB_DATABASE}" --retention=0s --host="${INFLUXDB_URL}" && \
    influx telegrafs create -n "MQTT" -d "telegraf config with mqtt." -f "/shared/telegraf/telegraf.conf"
  then
    touch "/shared/.initialized-influx"
    token_response=$(influx auth create --org="granja" --description="for telegraf" --all-access)
    token=$(echo "$token_response" | awk '{print $4}' | sed 's/User[\s+]*//g')
    echo "$token" > "/shared/token"
  fi
fi

if [ ! -f "/shared/.initialized-telegraf" ]; then
  python3 /shared/config.py
  touch "/shared/.initialized-telegraf"
fi

wait
