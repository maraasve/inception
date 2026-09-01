#!/bin/bash

set -e

# Generate SSL certificate
if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    echo "Generating SSL certificate..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout "$KEY_FILE" \
        -out "$CERT_FILE" \
        -subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=42/OU=Codam/CN=${DOMAIN_NAME}"
else
    echo "SSL certificate already exists, skipping generation."
fi


NGINX_CONF="/etc/nginx/sites-available/default"

sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/g" "$NGINX_CONF"

echo "Starting nginx..."

nginx -g "daemon off;"