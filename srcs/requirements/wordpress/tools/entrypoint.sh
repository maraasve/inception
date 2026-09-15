#!/bin/bash

set -e

cd /var/www/html

while ! mariadb-admin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    sleep 1
done

if [ ! -f wp-config.php ]; then
    echo "Setting up wordpress configuration"
	cp wp-config-sample.php wp-config.php

	sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
	sed -i "s/username_here/${MYSQL_USER}/" wp-config.php
	sed -i "s/password_here/${MYSQL_PASSWORD}/" wp-config.php
	sed -i "s/localhost/${MYSQL_HOST}/" wp-config.php
fi

echo "Configuration is ready"

if ! wp core is-installed --allow-root --url="$DOMAIN_NAME"; then
    echo "Starting wordpress installation"
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
    
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
fi

echo "Wordpress is installed"

chown -R www-data:www-data /var/www/html

exec php-fpm8.2 -F