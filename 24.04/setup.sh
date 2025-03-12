#!/bin/bash

USER_BIN="~/bin"
PHP_VERSION="8.3"
GOLANG_VERSION="1.24.1"

apt update -y
apt upgrade -y


function create_bin_directory() {
    if [[ -d "$USER_BIN" ]]; then
        echo "$USER_BIN is exist"
    else 
        echo "$USER_BIN does not exist";
        mkdir $USER_BIN
    fi
}

function install_tools() {
    apt install -y curl
    apt install -y wget
}

function install_git() {
    apt install -y git
    git --version
}

function php_install() {
    apt install software-properties-common -y
    apt update -y
    add-apt-repository ppa:ondrej/php
    apt install -y php${PHP_VERSION} php${PHP_VERSION}-common php${PHP_VERSION}-cli
    apt install -y php${PHP_VERSION}-{bz2,curl,mbstring,intl,xml,zip,xdebug,apcu,redis,pdo_mysql}
    php -v
    php -m
}

function golang_install() {
    wget "https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz"
    rm -rf /usr/local/go && tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz
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

function install_symfony_binary() {
    wget https://get.symfony.com/cli/installer -O - | bash
    mv /root/.symfony5/bin/symfony /usr/local/bin/symfony
    symfony version
    symfony check:requirements
}

function redis_install() {
    apt install -y redis-server
    redis-server --version
}

function mariadb_install() {
    apt install -y mariadb-server
    mariadb --version
}

echo "--START--: $(date)"
create_bin_directory
install_tools
install_git
php_install
composer_install
install_symfony_binary
golang_install
nvm_install
redis_install
mariadb_install
echo "---END---: $(date)"
