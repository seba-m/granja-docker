#!/bin/bash

clear

# Verificar si se tienen permisos de root
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ser ejecutado como root" 
   exit 1
fi

function checkRoot() {
    if [ $(id -u) != "0" ]; then
        echo "Error: Debes ser root para ejecutar este script, por favor utiliza root para detener"
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

echo "Deteniendo docker-compose.yml..."

sudo docker-compose down

echo "El proyecto se ha detenido correctamente."
