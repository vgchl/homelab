#/bin/bash

BASE_PATH="${BASE_PATH:-$(pwd)}"

service_name="adguard"
image="adguard/adguardhome"

docker stop "$service_name"
docker rm "$service_name"
docker pull "$image"

set -e

docker run --rm --name "$service_name" \
    -v "$BASE_PATH/adguard/work:/opt/adguardhome/work:z" \
    -v "$BASE_PATH/adguard/conf:/opt/adguardhome/conf:z" \
    -p 53:53/tcp -p 53:53/udp \
    -p 80:80/tcp -p 443:443/tcp -p 443:443/udp -p 3000:3000/tcp \
    -p 853:853/tcp \
    -p 784:784/udp -p 853:853/udp -p 8853:8853/udp \
    -p 5443:5443/tcp -p 5443:5443/udp \
    "$image"
