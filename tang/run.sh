#/bin/bash

BASE_PATH="${BASE_PATH:-$(pwd)}"

service_name="tang"
image="padhihomelab/tang"

docker stop "$service_name"
docker rm "$service_name"
docker pull "$image"

set -e

docker run --rm --name "$service_name" \
    --volume "/var/home/core/tang/db:/db:z" \
    -p "9999:8080/tcp" \
    "$image"
