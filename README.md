# Docker

Notes & code & tools for Docker


## The story
- Docker command line is talking with server.
- In 2017 management commands cames in
- An Image is the application we want to run.
- A container is an instance of that image running as a process.
- Docker's default image registry is dockerhub.
- Containers only run as long as the command that it ran on startup run. Default command is defined in Dockerfile.
- Image is the application binaries and dependencies for app and the metadata on how to run it. Image is an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime. Image is not complete OS, no kernel, kernel modules (e.g. drivers).
-  


## Commands
``` 
    docker version 
``` 
``` 
    docker info
``` 
``` 
    docker container run --publish 80:80 nginx
```
In the background docker engine looked for an image called nginx, and pulled down the latest image from Docker hub, and then it started as a new process in a new container.
Give a virtual IP on a private network inside docker engine.
Also expose localport 80 on host and send all trafiic
from it to executable on port 80.
Static IP's and using IP's for talking to containers is an anti-pattern.

``` 
    docker container run --publish 80:80 --detach nginx
``` 
Detach tells Docker to run container in the background

``` 
    docker container ls
``` 
Running container status
``` 
    docker container ls -a
``` 
All container status
``` 
    docker container start ...
``` 
Start existing stopped container
``` 
    docker container run --publish 80:80 --detach --name nginx nginx
``` 
Set name for container
``` 
    docker container logs nginx
``` 
Container logs
``` 
    docker container top nginx
``` 
Procesess inside container
``` 
    docker container rm nginx
```
Remove stopped containers.
``` 
    docker container rm -f nginx
```
Remove containers.
``` 
    docker run --name mongo 
    docker container top mongo ( ps -aux | grep mongo )
```
List of running processes in specific container.

``` 
    docker container inspect <container>
```
Details of one container config.

``` 
    docker container inspect --format '{{ .NetworkSettings.IPAddress }}' webhost
```
IPAddress of one container.

``` 
    docker container stats (optional <container>)
```
Performance stats for all containers in realtime stream.

``` 
    docker container run -it <container>
```
Run new container interactively.
-t pseudo-tty, simulates a real terminal like ssh
-i interactive, keep session open to receive terminal input

``` 
    docker container exec -it <container>
```
Run additional command in existing container.

``` 
    docker container run -p 80:80 --name webhost -d <container>
    docker container port webhost
```
What ports are open in container.
Each container connect to a private virtual network "bridge", and that virtual network is automatically attached to Ethernet interface on host.
Each virtual network routes through NAT firewall on host IP.
All containers on a virtual network can talk to each other without -p.
Use different Docker network drivers to gain new abilities.

``` 
    docker network ls
```
Show networks

``` 
    docker network inspect 
```
Inspect a network

``` 
    docker network create --driver
```
Create a network with optional driver.

``` 
    docker network connect
    docker network disconnect
```
Attach and detach a network to/from on running container.
Bridge network is default docker virtual network, which is NAT'ed behind the host IP.
Host network is faster by skipping virtual networks but sacrifices security of container model.
Netork driver is build-in or 3rd party extension that give you virtual network features.
``` 
    docker network create my_network
    docker container run -d --name nginx --network my_network nginx
    docker network inspect my_network
    docker network connect old_nginx
    docker network inspect my_network
    docker network inspect bridge
```
old_nginx is now attached into two networks.

Automatic DNS Naming
Docker deamon has a build-in DNS server that containers use by default.
Containers in the same virtuall network can talk with its name.
Docker defaults the hostname to the container's name but we can set aliases.

``` 
    docker network create my_network
    docker container run -it --rm --name nginx_old --network my_network nginx:alpine
    docker container run -it --rm --name new_nginx --network my_network nginx:alpine ping  nginx_old    
```

DNS Round Robin

``` 
    docker container run -d --rm --name el1 --network my_network --network-alias search elasticsearch:2
    docker container run -d --rm --name el2 --network my_network --network-alias search elasticsearch:2
    docker container run -it --rm --name alpine1 --net my_network  nginx:alpine ping search:9200
    docker container run -it --rm --name centos1 --net my_network centos curl -s search:9200
    docker container run -it --rm --name alpine2 --net my_network  alpine nslookup search
```


Docker uses a Union file system to present a series of file system changes as an actual file system.
``` 
    docker history nginx:latest
```
Show layers of changes made in image.

``` 
    docker image inspect nginx:latest
```
Returns JSON metadata about the image.

``` 
    docker image tag nginx:latest pwera/nginx:1.0.0
```
Tag an image

``` 
    docker image build . -t myimage
```
Build image from Dockerfile

``` 
    docker image prune
```
 Clean up just "dangling" images

``` 
    docker system prune
```
Clean up everything

``` 
    docker system df
```
See space usage

Persistent Data
Containers are usually immutable and ephemeral
https://www.oreilly.com/ideas/an-introduction-to-immutable-infrastructure
Docker volumes are a configuration option for a container that creates a special location outside of that container's union file system to store unique data. This preserves it across container removals and allows us to attach it to whatever container we want. And the container just sees it like a local file path.
Bind mounts are simply us sharing or mounting a host directory, or file, into a container.

Volumes
``` Dockerfile:
    ...
    VOLUME /var/lib/something
    ...
```
Volumes needs manual deletion.

``` 
    docker volume ls
```
Volumes lives longer then containers.

Named Volumes
``` 
    docker container run -d -v myimage-volume:/var/lib/something nginx
    docker volume ls
    docker volume inspect myimage-volume
```

Bind Mounts
``` 
   ... run -v ${pwd}:/path/inside/container
```
Maps a host file or directory to a container file or directory. Two locations pointing to the same files. 
Can't use in Dockerfile, must be at container run stage.
We can define as readonly.



(47)


## Tools & Usage
- Docker Compose
- Docker Swarm
- Apache Mesos
- Kubernetes
- Containers without docker ie. Podman
- CRI-O
- Envoy
- Proxy
- Containerd
- Storage drivers


## Authors

* **Piotr Wera** - *Initial work* - [pwera](https://github.com/pwera)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

