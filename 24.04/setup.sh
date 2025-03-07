#!/bin/bash


apt update -y
apt upgrade -y

function php_install() {
    apt install software-properties-common -y
    apt update -y
    add-apt-repository ppa:ondrej/php
    apt install -y php8.3 php8.3-common php8.3-cli
    apt install -y php8.3-{bz2,curl,mbstring,intl,xml,zip,xdebug,apcu,redis}
    php -v
}

php_install

