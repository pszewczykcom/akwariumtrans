FROM php:8.5-fpm-alpine

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apk add --no-cache nginx supervisor nodejs npm

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock symfony.lock ./
RUN composer install --no-dev --no-scripts --optimize-autoloader --no-interaction

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY . .

RUN npm run build:css \
    && composer dump-autoload --optimize --no-dev \
    && APP_ENV=prod APP_SECRET=placeholder php bin/console importmap:install --no-interaction \
    && APP_ENV=prod APP_SECRET=placeholder php bin/console asset-map:compile --no-interaction \
    && mkdir -p var/cache var/log \
    && chown -R www-data:www-data var/ public/assets/ assets/vendor \
    && rm -rf node_modules

COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
