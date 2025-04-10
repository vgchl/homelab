#/bin/bash

BASE_PATH="${BASE_PATH:-$(pwd)}"

service_name="nginx"
image="nginx:1.25-alpine"

docker stop "$service_name"
docker rm "$service_name"
docker pull "$image"

set -e

docker run --rm --name "$service_name" \
    -p "80:80" \
    -p "443:443" \
    -v "${BASE_PATH}/nginx/conf:/etc/nginx/conf.d/:z" \
    -v "${BASE_PATH}/certbot/data/etc/letsencrypt:/etc/letsencrypt:z" \
    "$image"
