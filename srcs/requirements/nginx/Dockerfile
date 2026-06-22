FROM debian:bullseye-slim

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		nginx \
		openssl \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/default.conf /etc/nginx/conf.d/default.conf

COPY tools/run_nginx.sh /run_nginx.sh

EXPOSE 443

RUN chmod +x run_nginx.sh

ENTRYPOINT ["./run_nginx.sh"]

CMD ["nginx", "-g", "daemon off;"]