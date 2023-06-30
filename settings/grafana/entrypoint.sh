#!/bin/bash

grafana-server --config="/etc/grafana/grafana.ini" &

sleep 15

if [ ! -f "/shared/.initialized-grafana" ]; then
  if grafana-cli plugins install speakyourcode-button-panel && grafana-cli plugins install cloudspout-button-panel; then
    touch "/shared/.initialized-grafana"
  fi
fi

wait
