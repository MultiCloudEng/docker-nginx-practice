# Unprivileged nginx image: runs as a non-root user (uid 101) and listens on 8080,
# because ports below 1024 require root. Pinned version instead of "latest"
# so builds are reproducible.
FROM nginxinc/nginx-unprivileged:1.27-alpine

COPY --chown=nginx:nginx nginx.conf /etc/nginx/conf.d/default.conf
COPY --chown=nginx:nginx index.html /usr/share/nginx/html/index.html

USER nginx

EXPOSE 8080

# Docker marks the container "unhealthy" if nginx stops answering.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1:8080/healthz || exit 1
