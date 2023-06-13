import os
import toml
from dotenv import load_dotenv

load_dotenv()

def modify_kapacitor_config():
    kapacitor_conf_path = "./etc/kapacitor/kapacitor.conf"

    # Leer las variables de entorno
    influxdb_url = os.environ.get('INFLUXDB_URL')
    influxdb_username = os.environ.get('INFLUXDB_USERNAME')
    influxdb_password = os.environ.get('INFLUXDB_PASSWORD')

    # Cargar el archivo kapacitor.conf
    with open(kapacitor_conf_path, 'r') as file:
        kapacitor_conf = toml.load(file)

    # Modificar los campos relevantes
    kapacitor_conf['influxdb'][0]['urls'] = [influxdb_url]
    kapacitor_conf['influxdb'][0]['username'] = influxdb_username
    kapacitor_conf['influxdb'][0]['password'] = influxdb_password

    # Guardar los cambios en kapacitor.conf
    with open(kapacitor_conf_path, 'w') as file:
        toml.dump(kapacitor_conf, file)

def main():
    modify_kapacitor_config()

    print("Se ha modificado el archivo kapacitor.conf correctamente.")

if __name__ == '__main__':
    main()
