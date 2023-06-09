import os
import subprocess

def execute_bash_command(command):
    result = subprocess.run(command, shell=True, capture_output=True)
    return result.returncode

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

    # Leer las variables de .env
    with open('.env', 'r') as file:
        env_vars = file.readlines()

    influxdb_ip = ""
    influxdb_username = ""
    influxdb_password = ""
    telegraf_db = ""

    for line in env_vars:
        if line.startswith('INFLUXDB_URL='):
            influxdb_ip = line.split('=')[1].strip()
        elif line.startswith('INFLUXDB_USERNAME='):
            influxdb_username = line.split('=')[1].strip()
        elif line.startswith('INFLUXDB_PASSWORD='):
            influxdb_password = line.split('=')[1].strip()
        elif line.startswith('INFLUXDB_DATABASE='):
            telegraf_db = line.split('=')[1].strip()

    influx_plugins = f"""
        [[outputs.influxdb_v2]]
            urls = [ {influxdb_ip} ]
            username = {influxdb_username}
            password = {influxdb_password}
            database = {telegraf_db}
    """

    telegraf_conf = telegraf_conf.replace(
        "# # Configuration for sending metrics to InfluxDB 2.0",
        "# # Configuration for sending metrics to InfluxDB 2.0\n" + influx_plugins
    )

    # Guardar los cambios en telegraf.conf
    with open(telegraf_conf_path, 'w') as file:
        file.write(telegraf_conf)

def main():
    bash_exit_code = execute_bash_command('bash linux.bash')
    if bash_exit_code == 1:
        execute_bash_command('sudo python3 {}'.format(os.path.basename(__file__)))
        return

    modify_telegraf_config()

    print("Todas las tareas se han completado con éxito.")

if __name__ == '__main__':
    main()