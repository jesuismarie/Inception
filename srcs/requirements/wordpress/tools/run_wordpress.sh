#!/bin/bash

mkdir -p /var/www/html
cd /var/www/html

rm -rf *

wp core download --allow-root
ls -l /var/www/html

cp wp-config-sample.php wp-config.php

sed -i "s/define( 'DB_NAME', '.*' );/define( 'DB_NAME', '${MYSQL_DATABASE}' );/g" wp-config.php
sed -i "s/define( 'DB_USER', '.*' );/define( 'DB_USER', '${MYSQL_USER}' );/g" wp-config.php
sed -i "s/define( 'DB_PASSWORD', '.*' );/define( 'DB_PASSWORD', '${MYSQL_PASSWORD}' );/g" wp-config.php
sed -i "s/define( 'DB_HOST', '.*' );/define( 'DB_HOST', '${MYSQL_HOSTNAME}' );/g" wp-config.php

wp core install --url="$DOMAIN_NAME" \
	--title="$WORDPRESS_TITLE" \
	--admin_user="$WORDPRESS_ROOT_USERNAME" \
	--admin_password="$WORDPRESS_ROOT_PASSWORD" \
	--admin_email="$WORDPRESS_ROOT_EMAIL" \
	--skip-email --allow-root

wp user create "$WORDPRESS_USER_USERNAME" "$WORDPRESS_USER_EMAIL" \
	--role="$WORDPRESS_USER_ROLE" \
	--user_pass="$WORDPRESS_USER_PASSWORD" \
	--allow-root

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

if wp core update --allow-root; then
	echo "WordPress core updated successfully."
else
	echo "Failed to update WordPress core."
fi

sleep 10

mkdir -p /run/php
chown -R www-data:www-data /run/php

wp theme install "twentytwentytwo" --activate --allow-root;

exec php-fpm7.4 -F

# #!/bin/bash

# mkdir -p /var/www/html
# cd /var/www/html

# chown -R www-data:www-data /var/www/html/
# chmod -R 755 /var/www/html/

# if [ ! -e ./wp-config.php ]; then
# 	rm -rf *
# 	wp core download --allow-root
# 	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
# 	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
# 	sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
# 	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
# 	cp wp-config-sample.php wp-config.php

# 	wp core install \
# 		--url=$DOMAIN_NAME \
# 		--title=$WORDPRESS_TITLE \
# 		--admin_user=$WORDPRESS_ROOT_USERNAME \
# 		--admin_password=$WORDPRESS_ROOT_PASSWORD \
# 		--admin_email=$WORDPRESS_ROOT_EMAIL \
# 		--skip-email --allow-root

# 	wp user create $WORDPRESS_USER_USERNAME $WORDPRESS_USER_EMAIL \
# 		--role=$WORDPRESS_USER_ROLE \
# 		--user_pass=$WORDPRESS_USER_PASSWORD \
# 		--allow-root

# 	chmod -R a+w wp-config.php wp-content wp-content/plugins wp-content/themes wp-content/uploads
# 	chown -R www-data:www-data wp-config.php wp-content wp-content/plugins wp-content/themes wp-content/uploads
# fi

# if wp core update --allow-root; then
# 	echo "WordPress core successfully updated."
# else
# 	echo "Failed to update WordPress core."
# fi

# sleep 10

# /usr/sbin/php-fpm7.4 -F