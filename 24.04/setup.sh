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

function nvm_install() {
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
}

function composer_install() {
    EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
    then
        >&2 echo 'ERROR: Invalid installer checksum'
        rm composer-setup.php
        exit 1
    fi

    php composer-setup.php --quiet
    rm composer-setup.php
    mv composer.phar /usr/local/bin/composer
}


install_tools
php_install
composer_install
golang_install
nvm_install
