import os
import configparser
import yaml


def grafana():
    config = configparser.ConfigParser()
    config.read('/etc/grafana/grafana.ini')

    admin_user = os.environ.get('GRAFANA_USERNAME')
    admin_password = os.environ.get('GRAFANA_PASSWORD')

    config['security']['admin_user'] = admin_user
    config['security']['admin_password'] = admin_password

    with open('/etc/grafana/grafana.ini', 'w') as configfile:
        config.write(configfile)

def main():
    grafana()

if __name__ == '__main__':
    main()
