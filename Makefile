NAME = Inception

all: config_volumes up

config_volumes:
	@mkdir -p /home/$(USER)/data/mariadb
	@mkdir -p /home/$(USER)/data/wordpress

re: hard_down up

up:
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

down:
	@docker-compose -f ./srcs/docker-compose.yml down

hard_down:
	@docker-compose -f ./srcs/docker-compose.yml down -v

start:
	@docker-compose -f ./srcs/docker-compose.yml start

stop:
	@docker-compose -f ./srcs/docker-compose.yml stop

remove_volumes:
	@rm -rf /home/$(USER)/data

.PHONY: all re up down hard_down start stop config_volumes remove_volumes