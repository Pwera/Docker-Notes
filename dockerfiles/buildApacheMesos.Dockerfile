FROM ubuntu

RUN apt-get update 
RUN apt-get install wget -y && wget http://archive.apache.org/dist/mesos/1.8.0/mesos-1.8.0.tar.gz 
RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.0/cmake-3.15.0-Linux-x86_64.tar.gz && tar -xzf cmake-3.15.0-Linux-x86_64.tar.gz && cd cmake-3.15.0-Linux-x86_64 && cp * /usr/ -R
RUN apt-get install git -y && git clone --recursive https://github.com/apache/mesos
RUN apt-get install gcc g++ ninja-build build-essential libsasl2-dev libapr1-dev libsvn-dev -y 
RUN cd mesos && mkdir build && cd build && cmake -GNinja ..