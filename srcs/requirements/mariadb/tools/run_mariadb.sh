#!/bin/bash

service mariadb start

sleep 2

sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

service mariadb restart

cat <<EOF > db.sql
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

mysql < db.sql

rm db.sql

service mariadb stop

chown -R mysql:mysql /var/lib/mysql
chmod 700 /var/lib/mysql/my_db

exec mysqld