#!/bin/python

import os
import toml

def main():
    config = toml.load("./telegraf.conf") 
    token = open("/shared/token", "r").read().strip()

    influxdb_url = os.environ.get('INFLUXDB_URL').split(", ")
    influxdb_database = os.environ.get('INFLUXDB_DATABASE')
    influxdb_org = os.environ.get('INFLUXDB_ORG')
    influxdb_token = os.environ.get('INFLUXDB_TOKEN')

    config['outputs']['influxdb_v2']['urls'] = influxdb_url
    config['outputs']['influxdb_v2']['organization'] = influxdb_org
    config['outputs']['influxdb_v2']['bucket'] = influxdb_database
    config['outputs']['influxdb_v2']['token'] = token

    mosquitto_url = os.environ.get('MOSQUITTO_URL').split(", ")
    mosquitto_topics = os.environ.get('MOSQUITTO_TOPICS').split(", ")
    mosquitto_format = os.environ.get('MOSQUITTO_FORMAT')

    config['inputs']['mqtt_consumer']['servers'] = mosquitto_url
    config['inputs']['mqtt_consumer']['topics'] = mosquitto_topics
    config['inputs']['mqtt_consumer']['data_format'] = mosquitto_format

    with open('./telegraf.conf', 'w') as f:
        toml.dump(config, f)

if __name__ == '__main__':
    main()