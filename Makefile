TIMESTAMP               =`date +%s`
BRANCH                  =$(shell git rev-parse --abbrev-ref HEAD)
GIT_SHA                 =$(shell git rev-parse HEAD)
GIT_SHA_SHORT           =$(shell git rev-parse --short=7 HEAD)
BASE_DIR 								=$(shell pwd)
CURR_USER 							=$(shell whoami)

APP_NAME 								?=`grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN 								?=`grep 'version:' mix.exs | cut -d '"' -f2`
BUILD 									?=`git rev-parse --short HEAD`

.SILENT: ;               		# no need for @
.ONESHELL: ;             		# recipes execute in same shell
.NOTPARALLEL: ;          		# wait for this target to finish
.EXPORT_ALL_VARIABLES: ; 		# send all vars to shell
.SHELLFLAGS = -c
.DEFAULT_GOAL := install
Makefile: ;              		# skip prerequisite discovery

.PHONY: run test

install:
	./script/setup

run:
	./script/run
