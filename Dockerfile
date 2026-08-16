ARG CADDY_VERSION=2.10.2
ARG CLOUDFLARE_MODULE_VERSION=v0.2.4

FROM caddy:${CADDY_VERSION}-builder AS builder
ARG CLOUDFLARE_MODULE_VERSION
RUN xcaddy build --with github.com/caddy-dns/cloudflare@${CLOUDFLARE_MODULE_VERSION}

FROM caddy:${CADDY_VERSION}
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
