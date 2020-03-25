FROM pwera/development-ubuntu:latest

RUN apt-get update && apt-get install docker.io -y lsof make net-tools --no-install-recommends && \
    curl -L "https://github.com/docker/compose/releases/download/1.26.0-rc3/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose
RUN git clone https://github.com/apache/openwhisk-devtools && cd openwhisk-devtools/docker-compose
    
#docker image build -t myubuntu . -f Dockerfile && 
#docker container run -v /var/run/docker.sock:/var/run/docker.sock -it myubuntu bash