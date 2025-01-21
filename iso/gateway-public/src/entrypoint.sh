#!/bin/sh

echo "Setting secrets..."
export CF_API_TOKEN=$(cat /app/cloudflare-api-key.jwe | /usr/bin/clevis decrypt)

echo "Starting Caddy..."
exec $@
