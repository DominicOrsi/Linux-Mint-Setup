#!/bin/bash


set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"


echo Installing software now

sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update

sudo apt install php8.0

sudo apt install php8.0 libapache2-mod-php8.0

sudo apt install php8.0-mysql

sudo apt-get install php-xdebug

