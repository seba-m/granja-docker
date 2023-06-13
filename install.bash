#!/bin/bash

clear

# Verificar si se tienen permisos de root
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ser ejecutado como root" 
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
    if ! [ -f "./etc/telegraf/telegraf.conf" ]; then
        sudo touch ./etc/telegraf/telegraf.conf
        createTelegrafConfig
    fi
}

function createTelegrafConfig() {
    sudo docker pull telegraf
    sudo docker run --rm telegraf telegraf config > ./etc/telegraf/telegraf.conf
}

checkRoot
checkDocker
checkTelegrafConfig

echo "Instalando docker-compose.yml..."
sudo docker compose down
sudo docker compose build --no-cache --progress plain
sudo docker compose up -d

echo "La instalación ha finalizado correctamente."
