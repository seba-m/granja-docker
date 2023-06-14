#!/bin/bash

clear

# Verificar si se tienen permisos de root
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ser ejecutado como root" 
   exit 1
fi

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
else
    echo "No se ha encontrado el archivo .env"
    exit 1
fi

function checkRoot() {
    if [ $(id -u) != "0" ]; then
        echo "Error: Debes ser root para ejecutar este script, por favor utiliza root para instalar"
        exit 1
    fi
}

function checkDocker() {
    if [ ! -x "$(command -v docker)" ]; then
        installDocker
    fi
}

function installDocker() {
    sudo apt-get update
    sudo apt-get upgrade -y
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo systemctl status docker

    echo "Docker instalado correctamente"
}

function checkTelegrafConfig() {
    sudo rm -f ./etc/telegraf/telegraf.conf
    if ! [ -f "./etc/telegraf/telegraf.conf" ]; then
        sudo touch ./etc/telegraf/telegraf.conf
        createTelegrafConfig
    fi
}

function createTelegrafConfig() {
    sudo docker pull telegraf
    sudo docker run --rm telegraf telegraf config > ./etc/telegraf/telegraf.conf
    sudo python3 ./etc/telegraf/modify_telegraf_config.py
}

function checkKapacitorConfig() {
    sudo rm -f ./etc/kapacitor/kapacitor.conf
    if ! [ -f "./etc/kapacitor/kapacitor.conf" ]; then
        sudo touch ./etc/kapacitor/kapacitor.conf
        downloadKapacitorConfig
    fi
}

function downloadKapacitorConfig() {
    sudo docker pull kapacitor
    sudo docker run --rm kapacitor kapacitord config > ./etc/kapacitor/kapacitor.conf
    sudo python3 ./etc/kapacitor/modify_kapacitor_config.py
}

#create a function to check and install python

function checkPython() {
    if ! [ -x "$(command -v python3)" ]; then
        installPython
    fi
}

function installPython() {
    sudo apt-get install -y python3 python3-pip
    sudo pip3 install toml dotenv

    sudo apt-get install -y python3-toml python3-dotenv
}

checkRoot
#checkDocker
#checkTelegrafConfig
#checkKapacitorConfig

echo "Instalando docker-compose.yml..."

sudo docker stop $(sudo docker ps -aq)
sudo docker rm $(sudo docker ps -aq)
sudo docker rmi -f $(sudo docker images -aq)
sudo docker volume rm $(sudo docker volume ls -q)

sudo docker compose up --build --force-recreate -d

echo "La instalación ha finalizado correctamente."
