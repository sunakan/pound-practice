ARG DOCKER_DEBIAN_TAG
FROM debian:${DOCKER_DEBIAN_TAG}

RUN apt-get update
RUN apt-get install --assume-yes pound
COPY ./pound/pound.cfg /etc/pound/
COPY ./etc-default-pound /etc/default/pound
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT "/entrypoint.sh"
CMD ["sh"]
