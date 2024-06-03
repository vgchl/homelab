#!/bin/bash 
set -e

mkdir -p dist

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

if [ ! -f "certbot/certbot-cloudflare.ini" ]; then
    if [[ -z "$CLOUDFLARE_API_TOKEN" ]]; then
        echo "Error: CLOUDFLARE_API_TOKEN is required.";
        exit 1;
    fi
    echo "# Cloudflare API token used by Certbot
    dns_cloudflare_api_token = ${CLOUDFLARE_API_TOKEN}" > certbot/certbot-cloudflare.ini
fi

# Convert config from Butane to Ignition 
docker run --interactive --rm --security-opt label=disable \
    --volume ${PWD}:/pwd \
    --workdir /pwd \
    quay.io/coreos/butane:release \
    --pretty \
    --strict \
    --files-dir . \
    config-dest.yaml > dist/config-dest.ign

# Build ISO with Ignition config
rm -f dist/gateway.iso
docker run --privileged --rm \
    -v /dev:/dev -v /run/udev:/run/udev -v .:/data -w /data \
    quay.io/coreos/coreos-installer:release \
    iso customize \
    --dest-device /dev/sda \
    --dest-ignition dist/config-dest.ign \
    --output dist/gateway.iso \
    "$iso_path"

echo "Done!"
