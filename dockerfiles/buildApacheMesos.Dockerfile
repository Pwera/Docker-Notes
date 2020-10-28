# Maintained by Piotr Wera, piotr.wera@vp.pl

FROM pwera/development-ubuntu:latest

#RUN wget http://archive.apache.org/dist/mesos/1.8.0/mesos-1.8.0.tar.gz 

#RUN apt-get install git -y && git clone --recursive https://github.com/apache/mesos
RUN apt-get update && apt-get install build-essential libsasl2-dev libapr1-dev libsvn-dev libcurl4-openssl-dev p7zip-full -y 
#RUN cd mesos && mkdir build && cd build && cmake -GNinja .. && cmake --build .
WORKDIR /home
RUN wget http://bintray.com/apache/mesos/download_file?file_path=el7%2Fx86_64%2Fmesos-1.9.0-1.el7.x86_64.rpm
RUN wget http://bintray.com/apache/mesos/download_file?file_path=el7%2Fx86_64%2Fmesos-devel-1.9.0-1.el7.x86_64.rpm
RUN 7z x https://bintray.com/apache/mesos/download_file?file_path=el7%2Fx86_64%2Fmesos-devel-1.9.0-1.el7.x86_64.rpm
RUN 7z x https://bintray.com/apache/mesos/download_file?file_path=el7%2Fx86_64%2Fmesos-1.9.0-1.el7.x86_64.rpm

RUN  7z x mesos-1.9.0-1.el7.x86_64 -o.
RUN  7z x mesos-devel-1.9.0-1 -o.