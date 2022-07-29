FROM composer:2.0 as vendor

WORKDIR /app

COPY composer.json composer.json
COPY composer.lock composer.lock

# Install composer packages
RUN COMPOSER_CACHE_DIR=/dev/null composer install --no-interaction --no-scripts --classmap-authoritative

FROM php:8.1-alpine

ARG REVIEWDOG_VERSION=v0.14.1
ARG PHPCS_VERSION=3.9.5

COPY --from=vendor app/vendor/ /tmp/vendor/

# Install reviewdog
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

# Install phpcs
RUN wget -P /usr/local/bin -q https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${PHPCS_VERSION}/phpcs.phar \
 && chmod +x /usr/local/bin/phpcs.phar

# Unfortunately this is overridden by phpcs.xml
#RUN phpcs.phar --config-set installed_paths /tmp/vendor/wp-coding-standards/wpcs

RUN apk --no-cache add git \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /tmp
