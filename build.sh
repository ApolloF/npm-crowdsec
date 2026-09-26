#!/bin/sh
# Local build. Usage: ./build.sh [NPM_VERSION] [CS_BOUNCER_VERSION]   e.g. ./build.sh 2.16.0 v1.2.3
set -e
NPM=${1:-2.16.0}; CSB=${2:-v1.2.3}
cd "$(dirname "$0")"
docker build --pull --build-arg NPM_VERSION=$NPM --build-arg CS_BOUNCER_VERSION=$CSB -t local/npm-crowdsec:$NPM-cs$CSB .
echo "built local/npm-crowdsec:$NPM-cs$CSB"
