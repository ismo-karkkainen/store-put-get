#!/bin/sh

sudo yum install -y unzip docker >/dev/null
sudo amazon-linux-extras install ruby2.6 -y >/dev/null
test/port/install_aws.sh
rake test
