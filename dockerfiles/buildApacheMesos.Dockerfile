# Maintained by Piotr Wera, piotr.wera@vp.pl

FROM pwera/development-ubuntu:latest

#RUN wget http://archive.apache.org/dist/mesos/1.8.0/mesos-1.8.0.tar.gz 

RUN apt-get install git -y && git clone --recursive https://github.com/apache/mesos
RUN apt-get install build-essential libsasl2-dev libapr1-dev libsvn-dev -y 
RUN cd mesos && mkdir build && cd build && cmake -GNinja ..