#!/bin/bash
set -e

exec redis-server \
	--requirepass "$REDIS_PASSWORD" \
	--maxmemory 128mb \
	--maxmemory-policy allkeys-lru \
	--bind 0.0.0.0