#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $(basename $0) endpoint-url"
    exit 1
fi

aws dynamodb create-table --table-name test --attribute-definitions '[{"AttributeName":"prim","AttributeType":"S"},{"AttributeName":"sec","AttributeType":"S"}]' --key-schema '{"AttributeName":"prim","KeyType":"HASH"}' --global-secondary-indexes 'IndexName=idx,KeySchema=[{AttributeName=sec,KeyType=HASH}],Projection={ProjectionType=KEYS_ONLY}' --billing-mode PAY_PER_REQUEST --endpoint-url $1 >/dev/null 2>&1
