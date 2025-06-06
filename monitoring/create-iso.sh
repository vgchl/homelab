#!/bin/bash 
set -e

mkdir -p dist
mkdir -p dist/common

service="monitoring"

# Download ISO or use downloaded copy
iso_path="dist/fedora-coreos-live.x86_64.iso"
if [ ! -f "$iso_path" ]; then
    download_path=$(docker run --privileged --rm \
        -v /dev:/dev -v /run/udev:/run/udev -v .:/data -w /data \
        quay.io/coreos/coreos-installer:release \
        download \
        --format iso \
        --architecture x86_64 \
        --decompress)
    mv "$download_path" "$iso_path"
fi

for path in ../common/*.yaml; do 
    file=$(basename "$path" ".yaml") 
    docker run --interactive --rm --security-opt label=disable \
        --volume ${PWD}/../common:/pwd \
        --workdir /pwd \
        quay.io/coreos/butane:release \
        --pretty \
        --strict \
        --files-dir . \
        ${file}.yaml > dist/common/${file}.ign
done

docker run --interactive --rm --security-opt label=disable \
    --volume ${PWD}:/pwd \
    --workdir /pwd \
    quay.io/coreos/butane:release \
    --pretty \
    --strict \
    --files-dir . \
    config-dest.yaml > dist/config-dest.ign

# Build ISO with Ignition config
rm -f "dist/${service}.iso"
docker run --privileged --rm \
    -v /dev:/dev -v /run/udev:/run/udev -v .:/data -w /data \
    quay.io/coreos/coreos-installer:release \
    iso customize \
    --dest-device /dev/sda \
    --dest-ignition dist/config-dest.ign \
    --output dist/${service}.iso \
    "$iso_path"

echo "Done!"
