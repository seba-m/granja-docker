#!/bin/bash

INFLUXDB_TOKEN=$(cat /shared/token)

chronograf --influxdb-url "${INFLUXDB_URL}" --influxdb-org "${INFLUXDB_ORG}" --influxdb-token "${INFLUXDB_TOKEN}" --reporting-disabled
