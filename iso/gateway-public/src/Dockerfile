FROM docker.io/library/caddy:2.9.1-builder-alpine AS builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare


FROM docker.io/library/caddy:2.9.1-alpine

RUN apk add --no-cache \
            curl

RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
            'clevis==19-r0'

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ADD entrypoint.sh /usr/bin/entrypoint.sh
ADD cloudflare-api-key.jwe /app/cloudflare-api-key.jwe 

RUN ["chmod", "+x", "/usr/bin/entrypoint.sh"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]