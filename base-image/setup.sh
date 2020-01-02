#!/usr/bin/env bash

set -o errexit
set -o pipefail

install_dependencies () {
    sudo apt-get -y upgrade
    sudo apt-get -y update
    wget https://bootstrap.pypa.io/get-pip.py
    sudo python3 get-pip.py
    sudo pip install pipenv
    sudo apt-get install -y nginx
    sudo apt-get install -y supervisor
}

install_python_3_7(){
    sudo apt-get install -y build-essential \
    checkinstall \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    zlib1g-dev \
    openssl \
    libffi-dev \
    libpq-dev\
    python3-dev \
    python3-setuptools \
    wget

    # Prepare to build
    mkdir /tmp/Python37
    cd /tmp/Python37

    # Pull down Python 3.7, build, and install
    wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz
    tar xvf Python-3.7.0.tar.xz
    cd /tmp/Python37/Python-3.7.0
    ./configure
    sudo make install
}

main () {
    install_dependencies
    install_python_3_7
}

main "$@"