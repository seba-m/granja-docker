#!/bin/bash

# Verificar si se tienen permisos de root
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ser ejecutado como root" 
   exit 1
fi

# Ejecutar el archivo main.py en la carpeta auto_conf
echo "Ejecutando main.py en auto_conf..."
python3 "./auto_conf/main.py"

# Instalar docker-compose.yml
echo "Instalando docker-compose.yml..."
docker-compose up -d

echo "La instalación ha finalizado correctamente."
