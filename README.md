# Docker Practice: Hardened nginx Container

A small static site served by nginx in a container, built with a few container-security basics: non-root user, health check, pinned base image and security headers.

## What this demonstrates

| Topic | Implementation |
|---|---|
| Non-root container | `nginxinc/nginx-unprivileged` base image, `USER nginx` (uid 101), listens on **8080** because ports below 1024 need root |
| Reproducible builds | Base image pinned to `1.27-alpine` instead of `latest` |
| Health check | `HEALTHCHECK` calls a `/healthz` endpoint; Docker shows `healthy` / `unhealthy` |
| Hardened config | `server_tokens off` (hides nginx version), security headers (`X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `Content-Security-Policy`) |
| Small build context | `.dockerignore` |
| CI | GitHub Actions: hadolint, build, wait for `healthy`, smoke tests incl. "not running as root" |

## Usage

```bash
docker build -t practice .
docker run -d --name practice -p 8080:8080 practice
curl http://localhost:8080            # the page
curl http://localhost:8080/healthz    # ok
docker ps                             # STATUS shows (healthy)
docker exec practice id               # uid=101(nginx), not root
docker rm -f practice                 # cleanup
```

## Files

```
Dockerfile     # image definition
nginx.conf     # server block: port 8080, headers, /healthz
index.html     # the page
.dockerignore
```

## What was tested

- `hadolint` on the Dockerfile: no findings.
- `nginx.conf` validated with `nginx -t` and served with a local nginx 1.24: `/` returns 200, `/healthz` returns `ok`, unknown paths return 404, all security headers present, version hidden.
- `docker build` could not be run in my review environment (container registries were blocked there). The GitHub Actions workflow builds the image, waits for `healthy` and runs the smoke tests on every push.

## What I learned

I explored the nginx config inside a running container (`docker exec`) to see where nginx serves files from (`/usr/share/nginx/html`) and why the `COPY` destination matters. I then moved from the root-running `nginx:latest` to an unprivileged, pinned image.

## Skills

Docker, Dockerfile best practices, nginx, container security basics, health checks, CI.
