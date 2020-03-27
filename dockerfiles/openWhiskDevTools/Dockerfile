# Maintained by Piotr Wera, piotr.wera@vp.pl
FROM pwera/development-ubuntu:latest

# VARIABLES
ARG COMPOSE_VERSION=1.26.0-rc3
ARG COMPOSE_URL="https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64"

ENV DOCKER_HOST_IP=localhost
ENV DOCKER_COMPOSE_HOST=localhost
# PACKAGES
RUN apt-get update && apt-get install docker.io -y lsof make net-tools iputils-ping --no-install-recommends
RUN curl -L ${COMPOSE_URL} -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose
RUN git clone https://github.com/apache/openwhisk-devtools && cd openwhisk-devtools/docker-compose


# COMMENTS     
#docker image build -t myopenwhisk .
#docker container run -v /var/run/docker.sock:/var/run/docker.sock --rm --net host -it myopenwhisk bash
#docker container run -v /var/run/docker.sock:/var/run/docker.sock --rm --net host -it pwera/openWhiskDevTools bash