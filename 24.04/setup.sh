#!/bin/bash


apt update -y
apt upgrade -y


function install_tools() {
    apt install -y curl
    apt install -y wget
}

function php_install() {
    apt install software-properties-common -y
    apt update -y
    add-apt-repository ppa:ondrej/php
    apt install -y php8.3 php8.3-common php8.3-cli
    apt install -y php8.3-{bz2,curl,mbstring,intl,xml,zip,xdebug,apcu,redis}
    php -v
}

function golang_install() {
    wget https://go.dev/dl/go1.24.0.linux-amd64.tar.gz
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.0.linux-amd64.tar.gz
    echo "export PATH=\$PATH:/usr/local/go/bin" >> $HOME/.profile
    go version
}

install_tools
php_install
golang_install

