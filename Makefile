LIGHT_PURPLE	= \033[1;35m
RESET			= \033[0m

DATA_PATH		= /home/$(USER)/data
WORDPRESS_PATH	= $(DATA_PATH)/wordpress
MARIADB_PATH	= $(DATA_PATH)/mariadb

all: create_dirs up

create_dirs:
	@mkdir -p $(WORDPRESS_PATH)
	@mkdir -p $(MARIADB_PATH)
	@echo "${LIGHT_PURPLE}Data directories created at $(DATA_PATH)${RESET}"

up:
	@echo "${LIGHT_PURPLE}Starting up containers...${RESET}"
	@docker-compose -f ./srcs/docker-compose.yml up -d --build
	@echo "${LIGHT_PURPLE}Containers are up! Access your site at https://$(USERNAME).42.fr${RESET}"

down:
	@echo "${LIGHT_PURPLE}Shutting down containers...${RESET}"
	@docker-compose -f ./srcs/docker-compose.yml down
	@echo "${LIGHT_PURPLE}Done.${RESET}"

hard_down:
	@echo "${LIGHT_PURPLE}Shutting down containers and removing named volumes...${RESET}"
	@docker-compose -f ./srcs/docker-compose.yml down -v
	@echo "${LIGHT_PURPLE}Done.${RESET}"

start:
	@echo "${LIGHT_PURPLE}Starting containers...${RESET}"
	@docker-compose -f ./srcs/docker-compose.yml start
	@echo "${LIGHT_PURPLE}Done.${RESET}"

stop:
	@echo "${LIGHT_PURPLE}Stopping containers...${RESET}"
	@docker-compose -f ./srcs/docker-compose.yml stop
	@echo "${LIGHT_PURPLE}Done.${RESET}"

clean: down
	@echo "${LIGHT_PURPLE}Removing host data directories...${RESET}"
	@sudo rm -rf $(WORDPRESS_PATH)
	@sudo rm -rf $(MARIADB_PATH)
	@echo "${LIGHT_PURPLE}Host data cleaned.${RESET}"

fclean: clean
	@echo "${LIGHT_PURPLE}Removing project Docker images...${RESET}"
	@docker rmi my-nginx my-mariadb my-wordpress:php-fpm 2>/dev/null || true
	@echo "${LIGHT_PURPLE}Project images removed.${RESET}"

	@echo "${LIGHT_PURPLE}Clearing Docker build cache...${RESET}"
	@docker builder prune -f
	@echo "${LIGHT_PURPLE}Build cache cleared.${RESET}"

	@echo "${LIGHT_PURPLE}Full clean complete!${RESET}"

re: fclean all

.PHONY: all re up down hard_down start stop create_dirs clean fclean
