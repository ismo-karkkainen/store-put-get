#!/bin/sh

sudo zypper refresh >/dev/null
sudo zypper install --non-interactive unzip docker >/dev/null
sudo systemctl start docker.service >/dev/null
test/port/install_aws.sh
rake test
