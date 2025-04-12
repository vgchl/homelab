#!/bin/sh
set -euo pipefail

baseopts="list=echo,store=echo,delete=echo"

for file in $SECRETS_DIR/*.jwe; do
    name=$(basename $file ".jwe")
    if [ "$name" == "*" ]; then
      break
    fi
    opts="${baseopts},lookup=clevis decrypt < $file"
    podman secret rm "$name" || true
    podman secret create --driver=shell --driver-opts="${opts}" "$name" "$file"
done
