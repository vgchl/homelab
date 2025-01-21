#/bin/bash

BASE_PATH="${BASE_PATH:-$(pwd)}"

service_name="minecraft"
image="itzg/minecraft-server"

docker stop "$service_name"
docker rm "$service_name"
docker pull "$image"

set -e

docker run --rm --name "$service_name" \
    --env-file "$BASE_PATH/minecraft.env" \
    --volume "/var/data:/data:z" \
    -p "25565:25565/tcp" -p "8100:8100/tcp" \
    "$image"
