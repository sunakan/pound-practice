#DOCKER_DEBIAN_TAG := buster-slim
DOCKER_DEBIAN_TAG := stretch-slim
DOCKER_REPOSITORY := my-pound

CONTAINER_NAME := pound
WEB1_IP        := `cat /etc/hosts | grep 'web1' | awk '{ print $$1 }'`
WEB2_IP        := `cat /etc/hosts | grep 'web2' | awk '{ print $$1 }'`

define docker
	docker run \
		--rm \
		--interactive \
		--tty \
		--hostname ${CONTAINER_NAME} \
		--name ${CONTAINER_NAME} \
		--publish 80:80 \
		--mount type=bind,source=${PWD}/pound/,target=/etc/pound/,readonly \
		--mount type=bind,source=${PWD}/etc-default-pound,target=/etc/default/pound,readonly \
		--add-host web1:${WEB1_IP} \
		--add-host web2:${WEB2_IP} \
		--entrypoint "" \
		${DOCKER_REPOSITORY}:dev-latest
endef

.PHONY: build
build:
	docker build ./ \
		--build-arg DOCKER_DEBIAN_TAG=${DOCKER_DEBIAN_TAG} \
		--tag ${DOCKER_REPOSITORY}:dev-latest

.PHONY: bash
bash:
	$(call docker) bash

.PHONY: up
up:
	( docker container ls | grep ${CONTAINER_NAME} ) \
		|| $(call docker) /etc/init.d/pound start && bash

.PHONY: clean
clean:
	docker container stop ${CONTAINER_NAME} || echo ok
