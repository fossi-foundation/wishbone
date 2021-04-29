#!/usr/bin/env sh

set -e

cd $(dirname $0)/..

docker build -t wb/sphinx - <<EOF
FROM btdi/sphinx:py3-featured
RUN apk add make cairo cairo-dev
EOF

dcmd="docker run --rm -u $(id -u) -v /$(pwd)://tmp/src -w //tmp/src"

$dcmd wb/sphinx sh -c "
pip3 install -r src/requirements.txt
cd src/b3
make html latex
"

$dcmd btdi/latex:latest bash -c "
cd src/b3/build/latex
make
"
