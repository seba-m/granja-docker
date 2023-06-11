#!/bin/python

import os

def modify_telegraf_config():
    telegraf_conf_path = "/etc/telegraf/telegraf.conf"

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

    # Leer las variables de .env
    influxdb_url = os.environ.get('INFLUXDB_URL') || os.environ.get('URL')
    influxdb_username = os.environ.get('INFLUXDB_USERNAME') || os.environ.get('USERNAME')
    influxdb_password = os.environ.get('INFLUXDB_PASSWORD') || os.environ.get('PASSWORD')
    influxdb_database = os.environ.get('INFLUXDB_DATABASE') || os.environ.get('DB')
    influxdb_org = os.environ.get('INFLUXDB_ORG') || os.environ.get('ORG')

    token_file = "/shared/token"
    with open(token_file, 'r') as file:
        influxdb_token = file.read().strip()

    print(F"\n\n\n\n\n\nTOOOOOOOOOKEEEEEEEEN ${influxdb_token}\n\n\n\n\n\n\n")

    influx_plugins = f"""
[[outputs.influxdb_v2]]
    urls = [ "{influxdb_ip}" ]
    organization = "{telegraf_org}"
    bucket = "{telegraf_db}"
    token = "{influxdb_token}"
    """

    telegraf_conf = telegraf_conf.replace(
        "# # Configuration for sending metrics to InfluxDB 2.0",
        "# # Configuration for sending metrics to InfluxDB 2.0\n" + influx_plugins
    )

    # Guardar los cambios en telegraf.conf
    with open(telegraf_conf_path, 'w') as file:
        file.write(telegraf_conf)

def main():
    modify_telegraf_config()

    print("Todas las tareas se han completado con éxito.")

if __name__ == '__main__':
    main()