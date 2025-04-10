#!/bin/sh
set -e

baseopts="list=echo,store=echo,delete=echo"

for file in $SECRETS_DIR/*.jwe; do
    name=$(basename $file ".jwe")
    opts="${baseopts},lookup=clevis decrypt < $file"
    podman secret create --replace --driver=shell --driver-opts="${opts}" "$name" "$file"
done
