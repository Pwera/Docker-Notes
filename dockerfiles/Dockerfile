FROM ubuntu

RUN apt-get update 
RUN apt-get install wget -y && wget http://archive.apache.org/dist/mesos/1.8.0/mesos-1.8.0.tar.gz 
RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.0/cmake-3.15.0-Linux-x86_64.tar.gz && tar -xzf cmake-3.15.0-Linux-x86_64.tar.gz && cd cmake-3.15.0-Linux-x86_64 && cp * /usr/ -R
RUN apt-get install git -y
RUN apt-get update
RUN apt-get install gcc g++ ninja-build build-essential libsasl2-dev libapr1-dev libsvn-dev -y 
RUN git clone --recursive --single-branch --progress https://github.com/apache/mesos
RUN apt-get update
RUN apt-get install  libcurl4-openssl-dev libz-dev -y
RUN cd mesos && mkdir build && cd build && cmake -G"Unix Makefiles" ..
RUN cd mesos && cd build && cmake --build . --target leveldb-1.19
RUN cd mesos && cd build && cmake --build . --target protobuf-3.5.0 -- -j4
RUN cd mesos && cd build && cmake --build . --target boost-1.65.0
RUN cd mesos && cd build && cmake --build . --target zookeeper-3.4.8 -- -j4
RUN cd mesos && cd build && cmake --build . --target googletest-1.8.0 -- -j4
RUN cd mesos && cd build && cmake --build . --target glog-0.4.0 -- -j4
RUN cd mesos && cd build && cmake --build . --target libev-4.22 -- -j4
RUN cd mesos && cd build && cmake --build . --target grpc-1.10.0 -- -j4
RUN cd mesos && cd build && cmake --build . --target mesos-protobufs -- -j4
RUN cd mesos && cd build && cmake --build . --target process -- -j4

#RUN cd mesos && cd build && cmake --build . --target help

RUN cd mesos && cd build && cmake --build . --target mesos