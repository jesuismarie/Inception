FROM debian:bullseye

RUN apt update \
	&& apt upgrade -y \
	&& apt install -y \
	mariadb-client \
	mariadb-server \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/run_mariadb.sh /

EXPOSE 3306

RUN chmod +x run_mariadb.sh

ENTRYPOINT ["./run_mariadb.sh"]

CMD ["mysqld"]