#!/bin/bash

influxd &

sleep 20

if [ ! -f "/shared/.initialized" ]; then
  if influx setup --force=true --username=${INFLUXDB_USERNAME} --password=${INFLUXDB_PASSWORD} --org=${INFLUXDB_ORG} --bucket=${INFLUXDB_DATABASE} --token=${INFLUXDB_TOKEN} --retention=0s --host=${INFLUXDB_URL}; then
    touch "/shared/.initialized"
    exit 0
  fi
fi

wait