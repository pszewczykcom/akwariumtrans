FROM php:8.4-fpm-alpine

RUN apk add --no-cache nginx supervisor \
    && docker-php-ext-install opcache

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock symfony.lock ./
RUN composer install --no-dev --no-scripts --optimize-autoloader --no-interaction

COPY . .
# importmap:install downloads JS/CSS vendor files (bootstrap, stimulus, …) into assets/vendor/
# — required because composer install uses --no-scripts and .dockerignore excludes host vendor dirs
RUN composer dump-autoload --optimize --no-dev \
    && APP_ENV=prod APP_SECRET=placeholder php bin/console importmap:install --no-interaction \
    && APP_ENV=prod APP_SECRET=placeholder php bin/console asset-map:compile --no-interaction \
    && mkdir -p var/cache var/log \
    && chown -R www-data:www-data var/ public/assets/ assets/vendor

COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
