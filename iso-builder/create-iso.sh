#!/bin/bash 
set -e

mkdir -p dist

service_path=$1
service_name="{$2:-$(dirname $service_path)}"

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

# Convert config from Butane to Ignition 
docker run --interactive --rm --security-opt label=disable \
    --volume ${service_path}:/pwd \
    --workdir /pwd \
    quay.io/coreos/butane:release \
    --pretty \
    --strict \
    --files-dir . \
    butane-dest.yaml > "dist/ign/${service_name}-dest.ign"

# Build ISO with Ignition config
rm -f "dist/${service}.iso"
docker run --privileged --rm \
    -v /dev:/dev -v /run/udev:/run/udev -v "${service_path}:/data" -v ign:/ign  -w /data \
    quay.io/coreos/coreos-installer:release \
    iso customize \
    --dest-device /dev/sda \
    --dest-ignition "/ign/${service_name}-dest.ign" \
    --output "dist/iso/${service_name}.iso" \
    "$iso_path"

echo "Done!"
