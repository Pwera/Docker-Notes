FROM ubuntu:18.04

RUN apt-get update && apt-get update 
RUN apt install -y wget git unzip g++ libz-dev
RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.0/cmake-3.15.0-Linux-x86_64.tar.gz && tar -xzf cmake-3.15.0-Linux-x86_64.tar.gz && rm -rf cmake-3.15.0-Linux-x86_64/man/ && \
    cp -r /cmake-3.15.0-Linux-x86_64/. /usr/local/ && \
    rm cmake-3.15.0-Linux-x86_64.tar.gz && rm -rf cmake-3.15.0-Linux-x86_64 && \
    wget https://github.com/ninja-build/ninja/releases/download/v1.9.0/ninja-linux.zip && unzip ninja-linux.zip && mv ninja /usr/local/bin && rm ninja-linux.zip && \
    wget https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz && tar -xzf go1.12.6.linux-amd64.tar.gz && rm go1.12.6.linux-amd64.tar.gz && cp go/bin/go /usr/local/bin

#RUN git clone --single-branch --recursive https://github.com/protocolbuffers/protobuf 
#RUN cd /protobuf && cd cmake && mkdir build && cd build && cmake -GNinja -Dprotobuf_BUILD_TESTS=OFF  ..  && cmake --build . && cmake --build . --target install
RUN wget https://github.com/cdr/code-server/releases/download/1.1156-vsc1.33.1/code-server1.1156-vsc1.33.1-linux-x64.tar.gz && \
    tar xzf code-server1.1156-vsc1.33.1-linux-x64.tar.gz && \
    cd code-server1.1156-vsc1.33.1-linux-x64 && mv code-server /bin
    
RUN code-server --install-extension peterjausovec.vscode-docker  && \
    code-server --install-extension ms-vscode.go && \
    code-server --install-extension vector-of-bool.cmake-tools && \
    code-server --install-extension redhat.vscode-yaml && \
    code-server --install-extension ms-vscode.cpptools && \
    code-server --install-extension premparihar.gotestexplorer
RUN    code-server -N

#docker image build . -t developementubuntu && docker container run -it --rm --name ub -p 8443:8443 developementubuntu bash