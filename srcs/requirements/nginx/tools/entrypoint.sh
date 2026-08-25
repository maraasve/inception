#!/bin/bash

set -e

# Generate SSL certificate
openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=42/OU=Codam/CN=${DOMAIN_NAME}"

NGINX_CONF="/etc/nginx/sites-available/default"

sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/g" "$NGINX_CONF"

echo "Starting nginx..."

nginx -g "daemon off;"