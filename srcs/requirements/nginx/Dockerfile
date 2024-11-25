FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y nginx openssl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY conf/default.conf /etc/nginx/conf.d/default.conf

COPY tools/run_nginx.sh /

WORKDIR /

EXPOSE 443

RUN chmod +x run_nginx.sh

CMD ["./run_nginx.sh"]