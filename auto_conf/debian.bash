#!/bin/bash

function checkRoot() {
    if [ $(id -u) != "0" ]; then
        echo "Error: You must be root to run this script, please use root to install"
        exit 1
    fi
}

function checkDocker() {
    if [ ! -x "$(command -v docker)" ]; then
        installDocker();
    fi
}

function installDocker() {
    sudo apt-get update
    sudo apt-get upgrade
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo systemctl status docker

    echo "Docker installed successfully"
}

function checkTelegrafConfig() {
    if [ ! -f "../etc/telegraf/telegraf.conf" ]; then
        touch ../etc/telegraf/telegraf.conf
    fi
}

function createTelegrafConfig() {
    docker pull telegraf
    docker run --rm telegraf telegraf config > ../etc/telegraf/telegraf.conf
    exit 0
}

checkRoot();
checkDocker();
checkTelegrafConfig();
createTelegrafConfig();