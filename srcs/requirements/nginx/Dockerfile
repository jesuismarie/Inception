FROM debian:bullseye

ARG CERTS
ARG DOMAIN_NAME
ARG KEYOUT

ENV CERTS=${CERTS}
ENV DOMAIN_NAME=${DOMAIN_NAME}
ENV KEYOUT=${KEYOUT}

RUN apt update && apt upgrade -y

RUN apt install -y nginx openssl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY conf/default.conf /etc/nginx/conf.d/default.conf

COPY tools/run_nginx.sh /

WORKDIR /

EXPOSE 443

RUN chmod +x run_nginx.sh

CMD ["./run_nginx.sh"]

# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
# 	-keyout $KEYOUT -out $CERTS \
# 	-subj "/C=AM/ST=Yerevan/L=Yerevan/O=42/OU=student/CN=$DOMAIN_NAME"

# RUN sed -i "s#\$DOMAIN_NAME#$DOMAIN_NAME#g" /etc/nginx/conf.d/default.conf && \
# 	sed -i "s#\$CERTS#$CERTS#g" /etc/nginx/conf.d/default.conf && \
# 	sed -i "s#\$KEYOUT#$KEYOUT#g" /etc/nginx/conf.d/default.conf

# CMD ["nginx", "-g", "daemon off;"]