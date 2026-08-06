FROM ghcr.io/roadrunner-server/roadrunner:2025 AS roadrunner

FROM lagdo/alpine-php-grpc

ENV RR_CONFIG_FILE=/var/www/rr.yaml

# Copy PHP install script
COPY ./rr-entrypoint.sh /usr/local/bin/rr-entrypoint.sh

# RoadRunner
COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr

RUN set -xe && apk update && apk upgrade --no-cache --available && \
  install-php-extensions opcache zip intl sockets bcmath ctype phar \
    curl soap dom fileinfo gd mbstring openssl redis tokenizer && \
  chmod +x /usr/local/bin/rr-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/rr-entrypoint.sh"]

LABEL maintainer="Thierry Feuzeu <thierry.feuzeu@gmail.com>" \
  org.opencontainers.image.source="https://github.com/lagdo/docker-images" \
  org.opencontainers.image.description="RoadRunner and PHP with the GRPC module." \
  org.opencontainers.image.licenses="MIT License" \
  org.opencontainers.image.version="0.2.0"
