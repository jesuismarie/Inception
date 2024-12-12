FROM debian:bullseye

RUN apt update \
	&& apt upgrade -y \
	&& apt install -y \
	nginx \
	openssl \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY conf/default.conf /etc/nginx/conf.d/default.conf

COPY tools/run_nginx.sh /

EXPOSE 443

RUN chmod +x run_nginx.sh

ENTRYPOINT ["./run_nginx.sh"]

CMD ["nginx", "-g", "daemon off;"]