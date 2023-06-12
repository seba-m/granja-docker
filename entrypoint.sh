#!/bin/bash

set -e

/entrypoint.sh influxd &

until curl -s "${INFLUXDB_URL}/ping" > /dev/null; do
    sleep 1
done

if [ -f "/shared/.initialized" ]; then
  echo "InfluxDB already initialized. Skipping setup."
else
  echo "Initializing InfluxDB..."
  influx setup --force --username "${INFLUXDB_USERNAME:-USERNAME}" --password "${INFLUXDB_PASSWORD:-PASSWORD}" --org "${INFLUXDB_ORG:-ORG}" --bucket "${INFLUXDB_DATABASE:-DB}" --token "${INFLUXDB_TOKEN:-TOKEN}"
  touch "/shared/.initialized"
  echo "InfluxDB initialized successfully."
fi

if [ -f "/shared/token" ]; then
  echo "InfluxDB Token already initialized. Skipping setup."
else
  echo "Generating token..."
  response=$(influx auth create --org "${INFLUXDB_ORG:-ORG}" 	--operator)
  token=$(echo "$response" | awk '/Token:/{print $2}')

  if [[ $str != *"Error"* ]]; then
    echo "INFLUXDB_TOKEN=$token" > "/shared/token"
    echo "Token generated and stored in $TOKEN_FILE."
  fi
fi

wait $!
