#!/bin/bash

wait_for_influxdb() {
  echo "Waiting for InfluxDB to start..."

  while ! curl -s "${INFLUXDB_URL:-URL}/ping" > /dev/null; do
    sleep 1
  done

  echo "InfluxDB is up and running."
}

wait_for_influxdb

if [ -f "$MARKER_FILE" ]; then
  echo "InfluxDB already initialized. Skipping setup."
else
  echo "Initializing InfluxDB..."
  influx setup --force --username "${INFLUXDB_USERNAME:-USERNAME}" --password "${INFLUXDB_PASSWORD:-PASSWORD}" --org "${INFLUXDB_ORG:-ORG}" --bucket "${INFLUXDB_DATABASE:-DB}" --token "${INFLUXDB_TOKEN:-TOKEN}"
  touch "$MARKER_FILE"
  echo "InfluxDB initialized successfully."
fi

if [ -f "$TOKEN_FILE" ]; then
  echo "InfluxDB Token already initialized. Skipping setup."
else
  echo "Generating token..."
  response=$(influx auth create --org "${INFLUXDB_ORG:-ORG}" 	--operator)
  token=$(echo "$response" | awk '/Token:/{print $2}')

  if [[ $str != *"Error"* ]]; then
    echo "INFLUXDB_TOKEN=$token" > "$TOKEN_FILE"
    echo "Token generated and stored in $TOKEN_FILE."
  fi
fi

exit 1