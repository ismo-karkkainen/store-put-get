#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $(basename $0) output-file-name"
    echo "Helper script for automated builds. Redirects test output to a file."
    exit 1
fi

(
uname -a
ruby --version
rake freshtest
) >$1 2>&1
