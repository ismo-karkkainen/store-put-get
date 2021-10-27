#!/bin/sh

P="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"
if [ "$(uname -m)" = "x86_64" ]; then
    P="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
fi
curl "$P" -o "awscliv2.zip" >/dev/null
unzip awscliv2.zip >/dev/null
sudo ./aws/install
