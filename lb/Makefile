#DOCKER_DEBIAN_TAG := buster-slim
DOCKER_DEBIAN_TAG := stretch-slim
DOCKER_REPOSITORY := my-pound

define docker
	docker run \
		--rm \
		--interactive \
		--tty \
		--mount type=bind,source=${PWD}/pound/,target=/etc/pound/ \
		${DOCKER_REPOSITORY}:dev-latest
endef
#		--user `id -u`:`id -g` \

.PHONY: build
build:
	docker build ./ \
		--build-arg DOCKER_DEBIAN_TAG=${DOCKER_DEBIAN_TAG} \
		--tag ${DOCKER_REPOSITORY}:dev-latest

.PHONY: bash
bash:
	$(call docker) bash
