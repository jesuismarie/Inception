#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
	echo "[MariaDB] First run detected — initializing database..."

	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

	mysqld --user=mysql --skip-networking --bootstrap <<-EOF
		FLUSH PRIVILEGES;
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		FLUSH PRIVILEGES;
	EOF

	echo "[MariaDB] Initialization complete."
else
	echo "[MariaDB] Database already initialized — skipping setup."
fi

exec "$@"