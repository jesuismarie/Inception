FROM debian:bullseye-slim

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		redis-server \
	&& rm -rf /var/lib/apt/lists/*

COPY tools/run_redis.sh /run_redis.sh

RUN chmod +x /run_redis.sh

EXPOSE 6379

ENTRYPOINT ["/run_redis.sh"]

CMD ["redis-server"]