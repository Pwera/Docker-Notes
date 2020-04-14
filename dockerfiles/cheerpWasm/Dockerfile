# Maintained by Piotr Wera, piotr.wera@vp.pl
# WIP

FROM ubuntu:18.04

RUN /bin/bash -c "apt-get update && apt-get install software-properties-common -y" && \
	apt-get update && \
	/bin/bash -c "add-apt-repository ppa:leaningtech-dev/cheerp-ppa" && \
	apt-get install cheerp-core -y

RUN apt-get install nodejs npm -y --no-install-recommends && npm install http-server
WORKDIR /home

# Hello sample
ADD https://raw.githubusercontent.com/wiki/leaningtech/cheerp-meta/tutorials/hello_world/hello.cpp /home/hello/hello.cpp
ADD https://raw.githubusercontent.com/wiki/leaningtech/cheerp-meta/tutorials/hello_world/hello.html /home/hello/hello.html

# Dom sample
ADD https://raw.githubusercontent.com/wiki/leaningtech/cheerp-meta/tutorials/dom_access/dom.cpp /home/dom/dom.cpp
ADD https://raw.githubusercontent.com/wiki/leaningtech/cheerp-meta/tutorials/dom_access/dom.html /home/dom/dom.html

RUN /opt/cheerp/bin/clang++ -target cheerp hello/hello.cpp -o hello/hello.js && \
	/opt/cheerp/bin/clang++ -target cheerp dom/dom.cpp -o dom/dom.js
CMD nodejs hello/hello.js

# Environmental variables
ENV PATH=${PATH}:/node_modules/http-server/bin

# docker image build -t cheerp .
# docker container run -it --rm -p8080:8080 cheerp bash
