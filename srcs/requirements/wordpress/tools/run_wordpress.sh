#!/bin/bash

mkdir -p /var/www/html
cd /var/www/html

chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

if [ ! -e ./wp-config.php ]; then
	rm -rf *
	wp core download --allow-root
	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
	sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
	cp wp-config-sample.php wp-config.php

	wp core install --url=$DOMAIN_NAME \
		--title=$WORDPRESS_TITLE \
		--admin_user=$WORDPRESS_ROOT_USERNAME \
		--admin_password=$WORDPRESS_ROOT_PASSWORD \
		--admin_email=$WORDPRESS_ROOT_EMAIL \
		--skip-email --allow-root
	wp user create $WORDPRESS_USER_USERNAME $WORDPRESS_USER_EMAIL \
		--role=$WORDPRESS_USER_ROLE \
		--user_pass=$WORDPRESS_USER_PASSWORD \
		--allow-root

	chmod -R a+w wp-config.php wp-content wp-content/plugins wp-content/themes wp-content/uploads
	chown -R www-data:www-data wp-config.php wp-content wp-content/plugins wp-content/themes wp-content/uploads
fi

if wp core update --allow-root; then
	echo "WordPress core successfully updated."
else
	echo "Failed to update WordPress core."
fi

sleep 10

exec php-fpm7.4 -F