MAKEFLAGS += --silent

SHELL = /bin/bash

cnf ?= .env
ifneq ($(shell test -e $(cnf) && echo -n yes), yes)
	ERROR := $(error $(cnf) file not defined in current directory)
endif

include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

.DEFAULT_GOAL := up

.PHONY: up

up:
	docker compose up