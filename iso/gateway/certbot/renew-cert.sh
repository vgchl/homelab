#/bin/bash

BASE_PATH="${BASE_PATH:-$(pwd)}"

service_name="certbot"
image="certbot/dns-cloudflare"

docker stop "$service_name"
docker rm "$service_name"
docker pull "$image"

set -e

docker run --rm --name "$service_name" \
    -v "${BASE_PATH}/certbot/data/etc/letsencrypt:/etc/letsencrypt:z" \
    -v "${BASE_PATH}/certbot/data/var/lib/letsencrypt:/var/lib/letsencrypt:z" \
    -v "${BASE_PATH}/certbot/certbot.ini:/opt/certbot/certbot.ini:z" \
    -v "${BASE_PATH}/certbot/certbot-cloudflare.ini:/opt/certbot/certbot-cloudflare.ini:z" \
    "$image" certonly \
    --config /opt/certbot/certbot.ini \
    --dns-cloudflare \
    --dns-cloudflare-credentials /opt/certbot/certbot-cloudflare.ini \
    --domain *.home.vgchl.com
