#!/bin/sh

sudo yum install -y -q ruby rake docker unzip
test/port/install_aws.sh
rake test
