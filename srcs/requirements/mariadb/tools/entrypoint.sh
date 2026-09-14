#!/bin/bash

# if a cmd in this script fails, stop the script
set -e

# create dir for runtime files
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# check if mariadb is already initialised
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

	# start mariadb server and store pid for later use
	mariadbd --user=mysql &
	pid=$!

	# run mariadb admin client to send pings until server is ready to recieve clients
	until env -u MYSQL_HOST mariadb-admin \
		--protocol=socket \
		--socket=/run/mysqld/mysqld.sock \
		ping --silent; do
		sleep 1
	done

# temporarily run mariaDB client to run the following sql cmd with heredoc
	# create database
	# create user and grant permissions, user is allowed to connect from every host
	# change root password
	# load changed users, passwords and permissions
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

	# shut down mariadbd server and wait until it is completely shut down
	env -u MYSQL_HOST mariadb-admin \
		--protocol=socket \
		--socket=/run/mysqld/mysqld.sock \
		-u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
	wait $pid
fi

# run mariadbd in foreground
exec mariadbd --user=mysql --bind-address=0.0.0.0