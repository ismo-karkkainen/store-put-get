#!/bin/sh

(
out() {
  echo "####CODE $1"
  echo "####OUT"
  cat x1
  echo "####ERR"
  cat x2
  rm -f x1 x2
}

echo "####COMMAND Unit tests."
./unittest-storeputgetbase > x1 2> x2
out $?

) > $(basename $0 .sh).res
