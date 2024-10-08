import os
import toml
import yaml

def main():
    config = toml.load("/shared/telegraf/telegraf.conf") 
    token = open("/shared/token", "r").read().strip()

    influxdb_url = os.environ.get('INFLUXDB_URL', '').replace(" ", "").split(',')
    influxdb_database = os.environ.get('INFLUXDB_DATABASE')
    influxdb_org = os.environ.get('INFLUXDB_ORG')

    config['agent']['hostname'] = influxdb_org

    config['outputs']['influxdb_v2'][0]['urls'] = influxdb_url
    config['outputs']['influxdb_v2'][0]['organization'] = influxdb_org
    config['outputs']['influxdb_v2'][0]['bucket'] = influxdb_database
    config['outputs']['influxdb_v2'][0]['token'] = token

    mosquitto_url = os.environ.get('MOSQUITTO_URL', '').replace(" ", "").split(',')
    mosquitto_topics = os.environ.get('MOSQUITTO_TOPICS', '').replace(" ", "").split(',')
    mosquitto_format = os.environ.get('MOSQUITTO_FORMAT')

    config['inputs']['mqtt_consumer'][0]['servers'] = mosquitto_url
    config['inputs']['mqtt_consumer'][0]['topics'] = mosquitto_topics
    config['inputs']['mqtt_consumer'][0]['data_format'] = mosquitto_format

    config['outputs']['mqtt'][0]['servers'] = [s.replace('tcp://','') for s in mosquitto_url]
    config['outputs']['mqtt'][0]['data_format'] = mosquitto_format

    config['inputs']['http_listener_v2'][0]['data_format'] = mosquitto_format

    with open('/shared/telegraf/telegraf.conf', 'w') as f:
        toml.dump(config, f)

if __name__ == '__main__':
    main()
