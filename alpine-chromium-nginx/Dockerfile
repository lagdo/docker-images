FROM alpine:3.24

# Default values for env vars.
ENV NGINX_PORT=9222
ENV NGINX_ALLOW=127.0.0.2
ENV NGINX_DENY=all

# Installs latest Chromium package.
RUN set -xe && \
  apk update && \
  apk upgrade --no-cache --available && \
  apk add --no-cache sed runit nginx chromium \
    ttf-freefont font-noto-emoji font-montserrat && \
  mkdir -p /etc/service/chromium && \
  mkdir -p /etc/service/nginx

ENV CHROMIUM_BIN=/usr/bin/chromium-browser CHROMIUM_PATH=/usr/lib/chromium/

# Configure a proxy in Nginx for Chrome
COPY ./config/nginx.conf /etc/nginx/http.d/chromium.conf

# Configure Runit
COPY ./bin/runit.sh /sbin/runit.sh
COPY ./bin/chromium.sh /etc/service/chromium/run
COPY ./bin/nginx.sh /etc/service/nginx/run

RUN chmod +x /sbin/runit.sh && \
  chmod +x /etc/service/chromium/run && \
  chmod +x /etc/service/nginx/run && \
  # Add Chrome as a user
  mkdir -p /data/chromium && \
  adduser -D chromium && \
  chown -R chromium:chromium /data/chromium

# Run the container as root (required by Runit) # non-privileged
# USER chromium
WORKDIR /data/chromium

ENTRYPOINT [ "/sbin/runit.sh" ]

LABEL maintainer="Thierry Feuzeu <thierry.feuzeu@gmail.com>" \
  org.opencontainers.image.source="https://github.com/lagdo/docker" \
  org.opencontainers.image.description="A headless Chromium browser with Nginx running in front." \
  org.opencontainers.image.licenses="MIT License" \
  org.opencontainers.image.version="0.2.0"
