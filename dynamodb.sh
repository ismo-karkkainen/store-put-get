#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $(basename $0) up|down"
    echo "  Use up to start the DynamoDB container, down to stop it."
    exit 1
fi

if [ -n "$DYNAMODB" ]; then
    test "$1" = "up" && echo $DYNAMODB
    exit 0
fi

A="invalid"
case "$1" in
    down)
        A="stop"
        ;;
    up)
        A="start"
        ;;
esac

P="invalid"
case "$(uname -s)" in
    Darwin)
        P="macos"
        set -e
        docker-machine --help > /dev/null
        set +e
        ;;
    Linux)
        P="linux"
        ;;
esac

RC=0
if [ "$A" = "invalid" ]; then
    echo "First argument must be 0 or 1, got: $1"
    RC=2
fi

if [ "$P" = "invalid" ]; then
    echo "Unsupported OS: $(uname -s)"
    RC=3
fi

set -e
aws --help >/dev/null
docker --help > /dev/null
if [ "$P" = "macos" ]; then
    docker-machine --help > /dev/null
fi
set +e

function run {
    ID=$(docker ps --filter name=storeputget --format '{{.ID}}')
    if [ -z "$ID" ]; then
        docker run -d --name storeputget -p 8000:8000 amazon/dynamodb-local >/dev/null 2>&1
    fi
}

function macos_start {
    # Whether the machine exists or is running, this will ensure it.
    docker-machine create storeputget >/dev/null 2>&1
    docker-machine start storeputget >/dev/null 2>&1
    eval $(docker-machine env storeputget)
    set -e
    docker pull amazon/dynamodb-local >/dev/null 2>&1
    run
    E="http://$(echo $DOCKER_HOST | sed -e 's#^tcp://##' -e 's#:[0-9]*$##'):8000"
    ./dbsetup.sh $E
    set +e
    echo $E
}

function macos_stop {
    docker-machine stop storeputget >/dev/null 2>&1
    docker-machine rm -y storeputget >/dev/null 2>&1
}

function linux_start {
    set -e
    docker pull amazon/dynamodb-local >/dev/null 2>&1
    run
    E="http://127.0.0.1:8000"
    ./dbsetup.sh $E
    set +e
    echo $E
}

function linux_stop {
    ID=$(docker ps --filter name=storeputget --format '{{.ID}}')
    docker stop $ID
    docker rm $ID
}

if [ $RC -eq 0 ]; then
    ${P}_${A}
fi
exit $RC
