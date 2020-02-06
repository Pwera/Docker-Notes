# Maintained by Piotr Wera, piotr.wera@vp.pl

FROM ubuntu:18.04

# VARIABLES

ARG CMAKE_VERSION=3.16.3
ARG CMAKE_FILE=cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz
ARG CMAKE_LINK=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_FILE}
ARG NINJA_VERSION=1.10.0
ARG NINJA_FILE=ninja-linux.zip
ARG NINJA_LINK=https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/${NINJA_FILE}
ARG GO_VERSION=1.13.7
ARG GO_FILE=go${GO_VERSION}.linux-amd64.tar.gz
ARG GO_LINK=https://dl.google.com/go/${GO_FILE}
ARG CS_VERSION=1.39.2
ARG CS_FILE=code-server2.1692-vsc${CS_VERSION}-linux-x86_64.tar.gz
ARG CS_LINK=https://github.com/cdr/code-server/releases/download/2.1692-vsc${CS_VERSION}/${CS_FILE}
ARG RUST_VERSION=1.41.0
ARG RUST_DIR=rust-${RUST_VERSION}-x86_64-unknown-linux-gnu
ARG RUST_FILE=${RUST_DIR}.tar.gz
ARG RUST_LINK=https://static.rust-lang.org/dist/${RUST_FILE}

# PACKAGES

RUN apt-get update
RUN apt install -y wget git unzip g++ libz-dev && \
    wget ${CMAKE_LINK} && tar -C /usr/local -xzf ${CMAKE_FILE} --strip-components=1 && rm ${CMAKE_FILE} && \
    wget ${NINJA_LINK} && unzip ${NINJA_FILE} && mv ninja /usr/local/bin && rm ${NINJA_FILE} && \
    wget ${GO_LINK} && tar -C /usr/local -xzf ${GO_FILE} && rm ${GO_FILE} && \
    wget ${CS_LINK} && tar -C /bin/ -xzf ${CS_FILE} --strip-components=1 && rm ${CS_FILE} && \
    wget https://packages.ubuntu.com/bionic/curl && chmod +x curl && mv curl /usr/local/bin && \
    wget ${RUST_LINK} && tar -xzf ${RUST_FILE} && cd ${RUST_DIR} && ./install.sh && rm -rf ../${RUST_DIR} && rm ../${RUST_FILE}
    
    
RUN code-server --install-extension peterjausovec.vscode-docker  && \
    code-server --install-extension ms-vscode.go && \
    code-server --install-extension redhat.vscode-yaml && \
    code-server --install-extension ms-vscode.cpptools && \
    code-server --install-extension premparihar.gotestexplorer && \
	code-server --install-extension rust-lang.rust

RUN mkdir /home/go

# ENVIRONMENTAL VARS
ENV PATH=${PATH}:/usr/local/go/bin
ENV GOPATH=/home/go
ENV GOROOT=/usr/local/go

RUN go get -v github.com/ramya-rao-a/go-outline     && \
    go get -v github.com/mdempsky/gocode            && \
    go get -v github.com/uudashr/gopkgs/cmd/gopkgs  && \
    go get -v github.com/rogpeppe/godef				&& \
	go get -v github.com/sqs/goreturns              && \
	go get -v github.com/go-delve/delve/cmd/dlv


    
# COMMENTS 
# docker image build . -t developementubuntu && docker container run -it --rm --name ub -p 8080:8080 developementubuntu bash
# RUN git clone --single-branch --recursive https://github.com/protocolbuffers/protobuf 
# RUN cd /protobuf && cd cmake && mkdir build && cd build && cmake -GNinja -Dprotobuf_BUILD_TESTS=OFF  ..  && cmake --build . && cmake --build . --target install