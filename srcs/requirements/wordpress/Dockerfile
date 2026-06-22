FROM debian:bullseye-slim

ENV PHP_VERSION 7.4

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		curl \
		ca-certificates \
		php${PHP_VERSION} \
		php${PHP_VERSION}-fpm \
		php${PHP_VERSION}-cli \
		php${PHP_VERSION}-mysql \
		php${PHP_VERSION}-gd \
		php${PHP_VERSION}-mbstring \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php \
	&& chown -R www-data:www-data /run/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html
COPY tools/run_wordpress.sh /run_wordpress.sh

RUN chmod +x /run_wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/run_wordpress.sh"]

CMD ["php-fpm7.4", "-F"]