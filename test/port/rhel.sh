#!/bin/sh

sudo yum install -y -q ruby rake unzip podman
alias docker=podman
test/port/install_aws.sh
rake test
