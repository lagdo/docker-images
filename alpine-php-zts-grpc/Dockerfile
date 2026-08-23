ARG ALPINE_VERSION=3.24
ARG PHP_VERSION=8.4
ARG PROTOBUF_VERSION=5.35.1

# PHP extension installer
FROM mlocati/php-extension-installer:2 AS php-extension-installer

FROM php:${PHP_VERSION}-zts-alpine

ARG PROTOBUF_VERSION
RUN set -xe && \
  apk add --no-cache git autoconf libzip-dev freetype-dev icu-dev \
    libmcrypt-dev libxslt-dev pcre grpc-cpp grpc-dev $PHPIZE_DEPS && \
  pecl install protobuf-${PROTOBUF_VERSION} && \
  GRPC_VERSION=$(apk info grpc -d | grep grpc | cut -d- -f2) && \
  git clone --depth 1 -b v${GRPC_VERSION} https://github.com/grpc/grpc /tmp/grpc && \
  cd /tmp/grpc/src/php/ext/grpc && \
  phpize && \
  ./configure && \
  make && \
  make install && \
  rm -rf /tmp/grpc && \
  apk del --no-cache autoconf grpc-dev git $PHPIZE_DEPS && \
  echo "extension=grpc.so" > /usr/local/etc/php/conf.d/grpc.ini

COPY --from=php-extension-installer ["/usr/bin/install-php-extensions", "/usr/local/bin/install-php-extensions"]

# PHP Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Copy PHP install scripts
COPY ./php-command.sh /usr/local/bin/php-command.sh
COPY ./php-entrypoint.sh /usr/local/bin/php-entrypoint.sh
RUN chmod +x /usr/local/bin/php-command.sh && \
  chmod +x /usr/local/bin/php-entrypoint.sh

# By default, run composer install with no additional option
ENV RUN_COMPOSER=false
ENV COMMAND_DIR=/var/www
ENV COMMAND_USER=
ENV COMPOSER_OPTIONS=install

ENTRYPOINT ["/usr/local/bin/php-entrypoint.sh"]

LABEL maintainer="Thierry Feuzeu <thierry.feuzeu@gmail.com>" \
  org.opencontainers.image.source="https://github.com/lagdo/docker-images" \
  org.opencontainers.image.description="Threadsafe PHP with the GRPC module." \
  org.opencontainers.image.licenses="MIT License" \
  org.opencontainers.image.version="0.2.0"
