ARG FRANKENPHP_VERSION=1.12.5
ARG PHP_VERSION=8.4
ARG PROTOBUF_VERSION=5.35.1

# PHP extension installer
FROM mlocati/php-extension-installer:2 AS php-extension-installer

FROM dunglas/frankenphp:${FRANKENPHP_VERSION}-php${PHP_VERSION}-alpine

RUN set -xe && apk update && apk upgrade --no-cache --available

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

RUN install-php-extensions opcache zip intl sockets bcmath ctype phar \
  curl soap dom fileinfo gd mbstring openssl redis tokenizer

# PHP Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Copy PHP install scripts
COPY ./php-command.sh /usr/local/bin/php-command.sh
COPY ./php-entrypoint.sh /usr/local/bin/php-entrypoint.sh
RUN chmod +x /usr/local/bin/php-command.sh && \
  chmod +x /usr/local/bin/php-entrypoint.sh

# By default, run composer install with no additional option
ENV RUN_INSTALL=false
ENV COMMAND_USER=
ENV INSTALL_OPTIONS=install

ENTRYPOINT ["/usr/local/bin/php-entrypoint.sh"]
# We need to separate the list items with commas,
# or else Docker will preprend with "/bin/sh -c".
CMD ["--config", "/etc/frankenphp/Caddyfile", "--adapter", "caddyfile"]

LABEL maintainer="Thierry Feuzeu <thierry.feuzeu@gmail.com>" \
  org.opencontainers.image.source="https://github.com/lagdo/docker" \
  org.opencontainers.image.description="FrankenPHP with the GRPC module." \
  org.opencontainers.image.licenses="MIT License" \
  org.opencontainers.image.version="0.2.0"
