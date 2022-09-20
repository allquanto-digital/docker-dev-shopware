MAKEFLAGS += --silent

SHELL = /bin/bash

cnf ?= .env
ifneq ($(shell test -e $(cnf) && echo -n yes), yes)
	ERROR := $(error $(cnf) file not defined in current directory)
endif

DOCKERCOMPOSE=$(shell docker-compose &> /dev/null && echo docker-compose)

ifndef DOCKERCOMPOSE
	DOCKERCOMPOSE := docker compose
endif

include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

.DEFAULT_GOAL := up

.PHONY: up down get_pwaat

up:
	${DOCKERCOMPOSE} up -d && \
	${DOCKERCOMPOSE} logs -f

down:
	${DOCKERCOMPOSE} down && \
	:>docker_env

get_pwaat:
	${DOCKERCOMPOSE} exec \
	mysql \
	mysql -uroot \
		-pshhitsasecret \
		shopware \
		-Ne \
			"SELECT access_key \
			FROM sales_channel, \
			sales_channel_type \
			WHERE \
			sales_channel.type_id=sales_channel_type.id \
			and sales_channel_type.icon_name='default-building-shop' \
			LIMIT 1" 2>/dev/null
