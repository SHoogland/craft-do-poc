# composer dependencies
FROM composer as vendor
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

FROM craftcms/nginx:7.4

LABEL "org.opencontainers.image.source"="https://github.com/SHoogland/craft-do-poc"

# switch to the root user to install mysql tools
USER root
RUN apk add --no-cache mysql-client
USER www-data

# the user is `www-data`, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
COPY --chown=www-data:www-data ./craft ./craft
COPY --chown=www-data:www-data ./config ./config
COPY --chown=www-data:www-data ./modules ./modules
COPY --chown=www-data:www-data ./storage ./storage
COPY --chown=www-data:www-data ./templates ./templates
COPY --chown=www-data:www-data ./web ./web
