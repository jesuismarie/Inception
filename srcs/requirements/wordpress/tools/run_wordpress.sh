#!/bin/bash

mkdir -p /var/www/html
cd /var/www/html

rm -rf *

if wp core download --allow-root; then
	echo "WordPress core downloaded successfully."
else
	echo "Failed to download WordPress core. Exiting."
fi

if cp wp-config-sample.php wp-config.php; then
	echo "wp-config.php created."
else
	echo "Failed to create wp-config.php. Exiting."
	exit 1
fi

if sed -i "s/define( 'DB_NAME', '.*' );/define( 'DB_NAME', '${MYSQL_DATABASE}' );/g" wp-config.php && \
	sed -i "s/define( 'DB_USER', '.*' );/define( 'DB_USER', '${MYSQL_USER}' );/g" wp-config.php && \
	sed -i "s/define( 'DB_PASSWORD', '.*' );/define( 'DB_PASSWORD', '${MYSQL_PASSWORD}' );/g" wp-config.php && \
	sed -i "s/define( 'DB_HOST', '.*' );/define( 'DB_HOST', '${MYSQL_HOSTNAME}' );/g" wp-config.php; then
	echo "Database credentials updated in wp-config.php."
else
	echo "Failed to update database credentials in wp-config.php. Exiting."
fi

if wp core install --url="$DOMAIN_NAME" \
	--title="$WORDPRESS_TITLE" \
	--admin_user="$WORDPRESS_ROOT_USERNAME" \
	--admin_password="$WORDPRESS_ROOT_PASSWORD" \
	--admin_email="$WORDPRESS_ROOT_EMAIL" \
	--skip-email --allow-root; then
	echo "WordPress installed successfully."
else
	echo "Failed to install WordPress. Exiting."
fi

if wp user create "$WORDPRESS_USER_USERNAME" "$WORDPRESS_USER_EMAIL" \
	--role="$WORDPRESS_USER_ROLE" \
	--user_pass="$WORDPRESS_USER_PASSWORD" \
	--allow-root; then
	echo "WordPress user created successfully."
else
	echo "Failed to create WordPress user. Exiting."
fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

if wp core update --allow-root; then
	echo "WordPress core updated successfully."
else
	echo "Failed to update WordPress core."
fi

mkdir -p /run/php
chown -R www-data:www-data /run/php

if wp theme install twentytwentytwo --activate --allow-root; then
	echo "WordPress theme installed and activated successfully."
else
	echo "Failed to install and activate WordPress theme."
fi

exec "$@";