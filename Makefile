NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml -p $(NAME)

WP_DATA = $(HOME)/data/wordpress
DB_DATA = $(HOME)/data/mariadb

all: up

build:
	$(COMPOSE) build

up:
	mkdir -p $(WP_DATA) $(DB_DATA)
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

restart: down up

logs:
	$(COMPOSE) logs -f

clean: down

fclean:
	$(COMPOSE) down -v --rmi all
	rm -rf $(WP_DATA) $(DB_DATA)

re: fclean up

.PHONY: all build up down stop start restart logs clean fclean re