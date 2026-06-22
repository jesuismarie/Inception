#!/bin/bash
set -e

WP_PATH="/var/www/html"
cd "$WP_PATH"

PHP_FPM_CONF="/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"
if [ -f "$PHP_FPM_CONF" ]; then
	sed -i "s|^listen = .*|listen = 0.0.0.0:9000|" "$PHP_FPM_CONF"
fi

download_wordpress()
{
	if [ ! -f "wp-includes/version.php" ]; then
		echo "[WordPress] Downloading WordPress core..."
		wp core download --allow-root
		echo "[WordPress] Core downloaded successfully."
	else
		echo "[WordPress] Core already present — skipping."
	fi
}

configure_wordpress()
{
	if [ -f "wp-config.php" ]; then
		echo "[WordPress] wp-config.php already exists — skipping"
		return 0
	fi

	echo "[WordPress] Creating wp-config.php..."

	wp config create \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="$MYSQL_HOSTNAME" \
		--dbcharset="utf8mb4" \
		--force \
		--allow-root
}

install_wordpress()
{
	echo "[WordPress] Installing WordPress..."
	wp core install \
		--url="$DOMAIN_NAME" \
		--title="$WORDPRESS_TITLE" \
		--admin_user="$WORDPRESS_ROOT_USERNAME" \
		--admin_password="$WORDPRESS_ROOT_PASSWORD" \
		--admin_email="$WORDPRESS_ROOT_EMAIL" \
		--skip-email \
		--allow-root

	echo "[WordPress] Creating subscriber user..."
	wp user create "$WORDPRESS_USER_USERNAME" "$WORDPRESS_USER_EMAIL" \
		--role=subscriber \
		--user_pass="$WORDPRESS_USER_PASSWORD" \
		--allow-root
}

setup_redis()
{
	echo "[WordPress] Configuring Redis cache..."
	wp config set WP_REDIS_HOST redis --allow-root || true
	wp config set WP_REDIS_PASSWORD "$REDIS_PASSWORD" --allow-root || true
	wp config set WP_REDIS_PORT 6379 --type=constant --allow-root || true

	wp plugin install redis-cache --activate --allow-root || true
	wp redis enable --allow-root || true
}

install_theme()
{
	echo "[WordPress] Installing theme..."
	wp theme install twentytwentytwo --activate --allow-root || true
}

download_wordpress
configure_wordpress
echo "[WordPress] Waiting for MariaDB..."
until bash -c "echo > /dev/tcp/$MYSQL_HOSTNAME/3306" 2>/dev/null; do
	echo "[WordPress] Not ready — retrying in 2s..."
	sleep 2
done
echo "[WordPress] Database is ready."
if ! wp core is-installed --allow-root >/dev/null 2>&1; then
	install_wordpress
fi
setup_redis
install_theme

chown -R www-data:www-data "$WP_PATH"
chmod -R 755 "$WP_PATH"

echo "[WordPress] Ready. Starting PHP-FPM..."

exec "$@"
