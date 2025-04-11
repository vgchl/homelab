#!/usr/bin/env bash

set -euo pipefail

file=$1
pin_config=$2
pin=$(cat tools/pin-config-$pin_config.json | jq -c)

clevis="docker compose -f tools/docker-compose.yaml run --rm --no-TTY clevis"

cat $file | $clevis encrypt sss "$pin" -y
