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
        echo "Docker no está instalado. Por favor, instala Docker antes de ejecutar este script."
        exit 1
    fi
}

checkRoot
checkDocker

echo "Iniciando docker-compose.yml..."

sudo docker-compose up -d

echo "El proyecto se ha iniciado correctamente."
