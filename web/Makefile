DOCKER_GOLANG_TAG := 1.14-buster

CONTAINER_NAME := go-app
PUBLISH_PORT   := 8080
TMP_HOME       := ${PWD}/tmp/TMP_HOME/

define docker
	docker run \
		--detach \
		--rm \
		--interactive \
		--tty \
		--hostname ${CONTAINER_NAME} \
		--name ${CONTAINER_NAME} \
		--publish ${PUBLISH_PORT}:${PUBLISH_PORT} \
		--user `id -u`:`id -g` \
		--mount type=bind,source=${PWD}/app/,target=/go/src/app/ \
		--mount type=bind,source=${TMP_HOME},target=/tmp/home/ \
		--workdir /go/src/app/ \
		--env DOCKER_HOSTNAME=`hostname` \
		--env PORT=${PUBLISH_PORT} \
		--env HOME=/tmp/home/ \
		golang:${DOCKER_GOLANG_TAG}
endef

.PHONY: tmp-home
tmp-home:
	mkdir -p ${TMP_HOME}.cache

.PHONY: up
up: tmp-home
	(docker container ls | grep ${CONTAINER_NAME}) \
		|| $(call docker) go run ./main.go

.PHONY: bash
bash: tmp-home
	$(call docker) bash

.PHONY: clean
clean:
	rm -rf ${TMP_HOME}
	docker container stop ${CONTAINER_NAME} || echo ok
