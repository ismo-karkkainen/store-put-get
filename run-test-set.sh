#!/bin/sh

P="./test-$1-*.sh"
shift

RV=0
cd test
for S in $P
do
    echo $S "$@"
    $S "$@"
    B=$(basename $S .sh)
    if [ ! -f $B.good ]; then
        echo "No $B.good to compare with."
        continue
    fi
    ./compare $B.good $B.res
    if [ $? -eq 0 ]; then
        echo "Comparison ok."
    else
        RV=1
        echo "Good:"
        cat $B.good
        echo "Result:"
        cat $B.res
        echo "Diff:"
        diff $B.good $B.res
    fi
done
exit $RV
