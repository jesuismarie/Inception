#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout $KEYOUT -out $CERTS \
	-subj "/C=AM/ST=Yerevan/L=Yerevan/O=42/OU=student/CN=$DOMAIN_NAME"

cd /etc/nginx/conf.d/

if [ -f /etc/nginx/conf.d/default.conf ]; then
	sed -i "s#\$DOMAIN_NAME#$DOMAIN_NAME#g" /etc/nginx/conf.d/default.conf && \
	sed -i "s#\$CERTS#$CERTS#g" /etc/nginx/conf.d/default.conf && \
	sed -i "s#\$KEYOUT#$KEYOUT#g" /etc/nginx/conf.d/default.conf
fi

nginx -g "daemon off;"
