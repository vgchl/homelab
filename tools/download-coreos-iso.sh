#!/usr/bin/env bash

set -euo pipefail

PATH_TMP="$(pwd)/.tmp"
mkdir -p $PATH_TMP

coreos_iso_path="$PATH_TMP/fedora-coreos-live.x86_64.iso"
if [ ! -f "$coreos_iso_path" ]; then
    download_path=$(docker run --privileged --rm \
        -v /dev:/dev -v /run/udev:/run/udev -v $PATH_TMP:/data -w /data \
        quay.io/coreos/coreos-installer:release \
        download \
        --format iso \
        --architecture x86_64 \
        --decompress)
    mv "$PATH_TMP/$download_path" "$coreos_iso_path"
fi

echo "CoreOS ISO downloaded."
