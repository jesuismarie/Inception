FROM debian:bullseye-slim
 
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		mariadb-server \
	&& rm -rf /var/lib/apt/lists/*
 
COPY tools/run_mariadb.sh /run_mariadb.sh
 
RUN printf '[mysqld]\nbind-address = 0.0.0.0\nskip-name-resolve\nskip-log-bin\n' \
		>> /etc/mysql/mariadb.conf.d/99-docker.cnf \
	&& mkdir -p /run/mysqld \
	&& chown -R mysql:mysql /run/mysqld \
	&& chmod +x /run_mariadb.sh
 
EXPOSE 3306
 
ENTRYPOINT ["/run_mariadb.sh"]

CMD ["mysqld", "--user=mysql"]