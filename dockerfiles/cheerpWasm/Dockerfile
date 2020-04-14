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

# Pong sample
ADD https://raw.githubusercontent.com/wiki/leaningtech/cheerp-meta/tutorials/tutorial_1/pong5/pong.cpp /home/pong/pong.cpp
ADD https://gist.githubusercontent.com/Pwera/d49f93e5d99aac2ce5ae7cb7d0a383b1/raw/4118d7d4febe2e51090534fb5af91591cabf027c/pong.html /home/pong/pong.html

# xmlHttpRequest
ADD https://gist.githubusercontent.com/Pwera/16dfcc5e4eeeb19a316b130f1c8c3882/raw/738aba7c9afa530b825d921f7aa18d0a1eb50889/xmlHttpRequest.cpp xmlHttpRequest/xmlHttpRequest.cpp 
ADD https://gist.githubusercontent.com/Pwera/f41a029a3da4fe94d2571b5d2ab7182f/raw/7eee544a4509b4ba47e3a53e73a4b11bb11838a0/xmlHttpRequest.html xmlHttpRequest/xmlHttpRequest.html

# Compile samples
RUN /opt/cheerp/bin/clang++ -target cheerp hello/hello.cpp -o hello/hello.js && \
	/opt/cheerp/bin/clang++ -target cheerp dom/dom.cpp -o dom/dom.js && \
	/opt/cheerp/bin/clang++ -target cheerp pong/pong.cpp -o pong/pong.js && \
	/opt/cheerp/bin/clang++ -target cheerp xmlHttpRequest/xmlHttpRequest.cpp -o xmlHttpRequest/xmlHttpRequest.js



# Default command	
CMD nodejs hello/hello.js

# Environmental variables
ENV PATH=${PATH}:/node_modules/http-server/bin

# docker image build -t cheerp .
# docker container run -it --rm -p8080:8080 cheerp bash
