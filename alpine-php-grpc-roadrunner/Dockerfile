FROM ghcr.io/roadrunner-server/roadrunner:2025 AS roadrunner

FROM lagdo/alpine-php-grpc

RUN set -xe && apk update && apk upgrade --no-cache --available

RUN install-php-extensions opcache zip intl sockets bcmath ctype phar \
  curl soap dom fileinfo gd mbstring openssl redis tokenizer

# RoadRunner
COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr

CMD ["/usr/local/bin/rr", "serve", "-c", "/var/www/rr.yaml"]

LABEL maintainer="Thierry Feuzeu <thierry.feuzeu@gmail.com>" \
  org.opencontainers.image.source="https://github.com/lagdo/docker" \
  org.opencontainers.image.description="RoadRunner and PHP with the GRPC module." \
  org.opencontainers.image.licenses="MIT License" \
  org.opencontainers.image.version="0.1.0"
