#!/bin/python

import os
from dotenv import load_dotenv

load_dotenv()

def modify_telegraf_config():
    telegraf_conf_path = "./etc/telegraf/telegraf.conf"

    with open(telegraf_conf_path, 'r') as file:
        telegraf_conf = file.read()

    mosquitto_plugins = """
[[inputs.mqtt_consumer]]
    servers = ["tcp://localhost:1883"]
    topics = ["sensors/#"]
    data_format = "json"
    """

    telegraf_conf = telegraf_conf.replace(
        "# # Read metrics from MQTT topic(s)", 
        "# # Read metrics from MQTT topic(s)\n" + mosquitto_plugins
    )

    influxdb_url = os.environ.get('INFLUXDB_URL')
    influxdb_database = os.environ.get('INFLUXDB_DATABASE')
    influxdb_org = os.environ.get('INFLUXDB_ORG')
    influxdb_token = os.environ.get('INFLUXDB_TOKEN')

    influx_plugins = f"""
[[outputs.influxdb_v2]]
    urls = [ "{influxdb_url}" ]
    organization = "{influxdb_org}"
    bucket = "{influxdb_database}"
    token = "{influxdb_token}"
    """

    telegraf_conf = telegraf_conf.replace(
        "# # Configuration for sending metrics to InfluxDB 2.0",
        "# # Configuration for sending metrics to InfluxDB 2.0\n" + influx_plugins
    )

    with open(telegraf_conf_path, 'w') as file:
        file.write(telegraf_conf)

def main():
    modify_telegraf_config()

    print("Todas las tareas se han completado con éxito.")

if __name__ == '__main__':
    main()