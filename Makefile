MAKEFLAGS += --silent

SHELL = /bin/bash

cnf ?= .env
ifneq ($(shell test -e $(cnf) && echo -n yes), yes)
	ERROR := $(error $(cnf) file not defined in current directory)
endif

include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

.DEFAULT_GOAL := up

.PHONY: up down get_pwaat

up:
	docker-compose up -d && \
	docker-compose logs -f

down:
	docker-compose down && \
	:>docker_env

get_pwaat:
	docker-compose exec \
	mysql \
	mysql -uroot \
		-pshhitsasecret \
		-hmysql shopware \
		-Ne \
			"SELECT access_key \
			FROM sales_channel, \
			sales_channel_type \
			WHERE \
			sales_channel.type_id=sales_channel_type.id \
			and sales_channel_type.icon_name='default-building-shop' \
			LIMIT 1" 2>/dev/null
