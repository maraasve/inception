#!/bin/bash

set -e

# Generate SSL certificate
# [] bash test -> do cert and key file exist
# openssl req generates ssl/tls certificate and private key
# -x509 -> self signed x.509 certificate
# nodes -> no password for private key so nginx can start automatically
# -newkey rsa:2048 - > new private key with rsa algorithm of size 2048 bits
# subj -> information about the owner of the key
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


# save the path to nginx configuration in a variable
NGINX_CONF="/etc/nginx/sites-available/default"

# replace default domain name with our domain name in the nginx configuration file
sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/g" "$NGINX_CONF"

echo "Starting nginx..."

nginx -g "daemon off;"