#!/bin/bash

telegraf --config="/shared/telegraf/telegraf.conf" --watch-config="inotify" &

sleep 30

if [ ! -f "/shared/.initialized-telegraf" ]; then
  python3 /shared/telegraf/telegraf.py
  touch "/shared/.initialized-telegraf"
  exit 0
fi

wait
