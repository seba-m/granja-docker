#!/bin/bash

marker_file="/var/lib/influxdb/.initialized"

if [ -f "$marker_file" ]; then
  echo "InfluxDB already initialized. Skipping setup."
else
  echo "Initializing InfluxDB..."
  influx setup --force --username "${INFLUXDB_USERNAME}" --password "${INFLUXDB_PASSWORD}" --org "${INFLUXDB_USERNAME}" --bucket "${INFLUXDB_DATABASE}" --retention 0s --token "" --host "http://influxdb:8086"
  touch "$marker_file"
  echo "InfluxDB initialized successfully."
fi