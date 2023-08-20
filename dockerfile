ARG ALPINE_VERSION=3.18
FROM alpine:${ALPINE_VERSION}
LABEL Maintainer="Yannis Piot Pilot <yannis@piotpilot.eu>"
LABEL Description="Docker image to facilitate the creation of development environment (and because I'm also too lazy to do this natively on a server)"

WORKDIR /var/www/

RUN apk add --no-cache \
  curl \
  nginx \
  wget \
  git \
  php82 \
  php82-ctype \
  php82-curl \
  php82-dom \
  php82-fpm \
  php82-gd \
  php82-intl \
  php82-mbstring \
  php82-mysqli \
  php82-pdo_mysql \
  libpq-dev \
  php82-pdo_pgsql \
  php82-opcache \
  php82-openssl \
  php82-phar \
  php82-session \
  php82-xml \
  php82-xmlreader

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/conf.d /etc/nginx/conf.d/
COPY config/fpm-pool.conf /etc/php82/php-fpm.d/www.conf
COPY config/php.ini /etc/php82/conf.d/custom.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 
RUN chown -R nobody.nobody /var/www /run /var/lib/nginx /var/log/nginx

USER nobody

COPY --chown=nobody src/ /var/www/

EXPOSE 8080

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping