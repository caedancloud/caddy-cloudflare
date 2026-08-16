# Caddy with Cloudflare DNS

A generic Caddy image built from pinned upstream components with the
`caddy-dns/cloudflare` module compiled in. It contains no deployment-specific
Caddyfile, credentials, routes, or certificate data.

## Published image

GitHub Actions publishes multi-architecture (`linux/amd64`, `linux/arm64`)
images to:

```text
ghcr.io/caedancloud/caddy-cloudflare
```

Use an immutable digest in deployment configuration:

```yaml
image: ghcr.io/caedancloud/caddy-cloudflare@sha256:<digest>
```

Tags are provided for discovery and testing:

- `main` for the latest successful build from `main`;
- `sha-<commit>` for a specific source commit;
- `v*` for a Git tag.

## Build inputs

The Dockerfile pins:

- Caddy: `2.10.2`
- Cloudflare DNS module: `v0.2.4`

The build uses Caddy's official `-builder` image and `xcaddy`, then copies the
resulting binary into the matching official Caddy runtime image.

## Local verification

```bash
docker build -t caddy-cloudflare:test .
docker run --rm caddy-cloudflare:test caddy list-modules \
  | grep --fixed-strings --line-regexp dns.providers.cloudflare
```

## Release flow

1. Update and test the pinned build inputs.
2. Commit the change to `main`; CI publishes `main` and `sha-<commit>` tags.
3. Create a versioned Git tag when the image is ready for a stable release.
4. Copy the published image digest into the consuming deployment repository.

The consuming deployment supplies its own Caddyfile and a scoped Cloudflare API
token. This image only supplies the compiled DNS provider.
