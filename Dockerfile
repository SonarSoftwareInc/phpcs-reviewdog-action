FROM php:7.4-alpine

ARG REVIEWDOG_VERSION=v0.13.0
ARG PHPCS_VERSION=3.6.1

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && chmod +x /usr/local/bin/composer

# Install composer packages
RUN COMPOSER_CACHE_DIR=/dev/null composer install --no-interaction --no-scripts --classmap-authoritative

# Install reviewdog
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

# Install phpcs
RUN wget -P /usr/local/bin -q https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${PHPCS_VERSION}/phpcs.phar \
 && chmod +x /usr/local/bin/phpcs.phar

RUN apk --no-cache add git \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /tmp
