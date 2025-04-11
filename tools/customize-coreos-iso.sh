#!/usr/bin/env bash

set -euo pipefail

SERVICE="$1"

PATH_COMMON="$(pwd)/common"
PATH_SERVICE="$(pwd)/$SERVICE"
PATH_SERVICE_DIST="$PATH_SERVICE/dist"
PATH_SERVICE_DIST_COMMON="$PATH_SERVICE/dist/common"
PATH_RESULT="$PATH_SERVICE_DIST/$SERVICE.iso"

PATH_TMP="$(pwd)/.tmp"

# Clean up old builds (if any)
rm -rf "$PATH_SERVICE_DIST"

# Ensure folders exist
mkdir -p "$PATH_TMP"
mkdir -p "$PATH_SERVICE_DIST"
mkdir -p "$PATH_SERVICE_DIST_COMMON"

# Generate common ignition files
for path in $PATH_COMMON/*.yaml; do 
    file=$(basename "$path" ".yaml") 
    docker run --interactive --rm --security-opt label=disable \
        --volume $PATH_COMMON:/pwd \
        --workdir /pwd \
        quay.io/coreos/butane:release \
        --pretty \
        --strict \
        --files-dir . \
        ${file}.yaml > $PATH_SERVICE_DIST_COMMON/${file}.ign
done

# Generate ignition file
docker run --interactive --rm --security-opt label=disable \
    --volume $PATH_SERVICE:/pwd \
    --workdir /pwd \
    quay.io/coreos/butane:release \
    --pretty \
    --strict \
    --files-dir . \
    config-dest.yaml > $PATH_SERVICE_DIST/config-dest.ign

# Embed ignition file in ISO
docker run --privileged --rm \
    -v /dev:/dev \
    -v /run/udev:/run/udev \
    -v $PATH_SERVICE:/data \
    -v $PATH_TMP:/iso \
    -w /data \
    quay.io/coreos/coreos-installer:release \
    iso customize \
    --dest-device /dev/sda \
    --dest-ignition /data/dist/config-dest.ign \
    --output /data/dist/${SERVICE}.iso \
    "/iso/fedora-coreos-live.x86_64.iso"

echo "Built ISO for $SERVICE at $PATH_RESULT."
