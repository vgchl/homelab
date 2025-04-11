#!/usr/bin/env bash

set -euo pipefail

file=$1

clevis="docker compose -f tools/docker-compose.yaml run --rm --no-TTY clevis"

cat $file | $clevis decrypt
