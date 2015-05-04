#!/usr/bin/env bash

curl -sSL https://get.docker.com/ubuntu/ | sudo sh

cd /vagrant/
./build.sh
sleep 5
./run.sh
