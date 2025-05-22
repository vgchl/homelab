#!/bin/sh
set -euo pipefail

baseopts="list=echo -n,store=echo -n,delete=echo -n"

for file in $SECRETS_DIR/*.jwe; do
    name=$(basename $file ".jwe")
    if [ "$name" == "*" ]; then
      break
    fi
    lookup="echo -n \$(clevis decrypt < $file)"
    opts="${baseopts},lookup=${lookup}"
    podman secret rm "$name" || true
    podman secret create --driver=shell --driver-opts="${opts}" "$name" "$file"
done
