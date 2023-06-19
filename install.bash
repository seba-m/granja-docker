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

checkRoot
checkDocker

echo "Instalando docker-compose.yml..."

sudo docker stop $(sudo docker ps -aq)
sudo docker rm $(sudo docker ps -aq)
sudo docker rmi -f $(sudo docker images -aq)
sudo docker volume rm $(sudo docker volume ls -q)

sudo docker compose up --build --force-recreate -d

echo "La instalación ha finalizado correctamente."
