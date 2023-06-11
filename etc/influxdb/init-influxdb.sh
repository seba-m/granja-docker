#!/bin/bash

if [ -f "$MARKER_FILE" ]; then
  echo "InfluxDB already initialized. Skipping setup."
else
  echo "Initializing InfluxDB..."
  influx setup --force --username "${INFLUXDB_USERNAME:-USERNAME}" --password "${INFLUXDB_PASSWORD:-PASSWORD}" --org "${INFLUXDB_ORG:-ORG}" --bucket "${INFLUXDB_DATABASE:-DB}" --host "${INFLUXDB_URL:-URL}"
  touch "$MARKER_FILE"
  echo "InfluxDB initialized successfully."
fi


if [ -f "$TOKEN_FILE" ]; then
  echo "InfluxDB Token already initialized. Skipping setup."
else
  echo "Generating token..."
  response=$(influx auth create --org "${INFLUXDB_ORG:-ORG}" --all-access)
  token=$(echo "$response" | awk '/Token:/{print $2}')

  if [[ $str != *"error"* ]]; then
    echo "INFLUXDB_TOKEN=$token" > "$TOKEN_FILE"
    echo "Token generated and stored in $TOKEN_FILE."
  fi
fi