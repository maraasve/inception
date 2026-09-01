#!/bin/bash

# if a cmd in this script fails, stop the script
set -e

# create dir for runtime files
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# check if mariadb is already initialised
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

	mariadbd --user=mysql &
	pid=$!

	until env -u MYSQL_HOST mariadb-admin \
		--protocol=socket \
		--socket=/run/mysqld/mysqld.sock \
		ping --silent; do
		sleep 1
	done

# temporarily start mariaDB to run the following sql cmd with heredoc
	# create database
	# create user and grant permissions
	# change root password
env -u MYSQL_HOST mariadb \
--protocol=socket \
--socket=/run/mysqld/mysqld.sock \
-u root << EOF
	CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
	FLUSH PRIVILEGES;
EOF

	env -u MYSQL_HOST mariadb-admin \
		--protocol=socket \
		--socket=/run/mysqld/mysqld.sock \
		-u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
	wait $pid
fi

# run mariadbd in foreground -> PID1 process
exec mariadbd --user=mysql --bind-address=0.0.0.0