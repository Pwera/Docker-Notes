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
- Containers use Linux security primitives such as Linux kernel namespaces to sandbox different applications running on the same computers 
and control groups (cgroups) in order to avoid the noisy-neighbor problem, where one bad application is using all the available resources of a server and starving all other applications.
Containers are only possible due to the fact that the Linux OS provides some primitives, such as namespaces, control groups, layer capabilities, 
and more, all of which are leveraged in a very specific way by the container runtime and the Docker engine. 

- Linux kernel namespaces, such as process ID (pid) namespaces or network (net) namespaces, allow Docker to encapsulate or sandbox processes that run inside the container. 

- Control Groups make sure that containers cannot suffer from the noisy-neighbor syndrome, where a single application running in a container 
can consume most or all of the available resources of the whole Docker host. 
Control Groups allow Docker to limit the resources, such as CPU time or the amount of RAM, that each container is allocated.


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
docker container inspect -f "{{json .State}}" trivia | jq .
``` 
Print formatted state of the cointainer.

``` 
docker container stats (optional <container>)
```
Performance stats for all containers in realtime stream.

``` 
docker container run -it <container>
```
Run new container interactively.
-t pseudo-tty(teletypewriter), simulates a real terminal like ssh
-i interactive, keep session open to receive terminal input

``` 
    docker container exec -it <container>
```
Run additional command in existing container.

## Single-Host Network
Docker has defined a very simple
networking model, the so-called container network model (CNM), to specify the
requirements that any software that implements a container network has to fulfill.

This network implementation is based on the Linux bridge.
When the Docker daemon runs for the first time, it creates a Linux bridge and calls
it docker0.
Docker then creates a network with this Linux bridge and calls the network bridge. All the
containers that we create on a Docker host and that we do not explicitly bind to another
network leads to Docker automatically attaching to this bridge network.

IP address management (IPAM) block. IPAM is a
piece of software that is used to track IP addresses that are used on a computer. The
important part of the IPAM block is the Config node with its values for Subnet and
Gateway. The subnet for the bridge network is defined by default as 172.17.0.0/16. This
means that all containers attached to this network will get an IP address assigned by
Docker that is taken from the given range, which is 172.17.0.2 to
172.17.255.255. The 172.17.0.1 address is reserved for the router of this network
whose role in this type of network is taken by the Linux bridge. We can expect that the very
first container that will be attached to this network by Docker will get
the 172.17.0.2 address

By default, only egress traffic is allowed, and all ingress is blocked. What this means is
that while containerized applications can reach the internet, they cannot be reached by any
outside traffic. Each container attached to the network gets its own virtual ethernet (veth)
connection with the bridge. 


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

```
docker network create --driver bridge --subnet "10.1.0.0/16" test-net
```
specify our own subnet range when creating a network

## Images
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


```
docker container diff sample
```
If we want to see what has changed in our container in relation to the base image.

```
docker container run --name test -it --log-driver none busybox sh -c 'for N in 1 2 3; do echo "Hello $N"; done'
```
Docker supports several different graph drivers using a pluggable architecture. The preferred driver is overlay2, followed by overlay.


`FROM` scratch is a no-op in the Dockerfile, and as such does not generate a layer in the resulting container image.

`ADD` keyword also lets us copy and unpack TAR files, as well as providing a URL as a source for the files and folders to copy.

From a security perspective, it is important to know that, by default, all files and folders inside the image will have a user ID (UID) and a group ID (GID) of 0. 
The good thing is that for both `ADD` and `COPY`, we can change the ownership that the files will have inside the image using the optional --chown flag, as follows

```ADD --chown=11:22 ./data/web* /app/data/```

The `CMD` and `ENTRYPOINT` keywords are special. 
While all other keywords defined for a Dockerfile are executed at the time the image is built by the Docker builder, these two are actually definitions of what will happen when a container is started from the image we define

```
docker container run --rm -it --entrypoint /bin/sh pinger
```
Override what's defined in the `ENTRYPOINT`

If you leave `ENTRYPOINT` undefined, then it will have the default value of /bin/sh -c, and whatever the value of `CMD` is will be passed as a string to the shell command.

```
docker container run --rm -it --env-file ./development.config alpine sh -c "export"
 ```
 Override Environmentals.

```
$ docker image build \    
--build-arg BASE_IMAGE_VERSION=12.7-alpine \    
-t my-node-app-test .
```
 Override Dockerfile arguments.

 ```
docker container run --rm -it \
-v $(pwd):/usr/src/app \
-w /usr/src/app \
perl:slim sh -c "cat sample.txt | perl -lpe 's/^\s*//'"
```
Remove spaces from file, using perl

```
docker container run --rm \
 --name shellinabox \
 -p 4200:4200 \
 -e SIAB_USER=gnschenker \
 -e SIAB_PASSWORD=top-secret \
 -e SIAB_SUDO=true \
 -v `pwd`/dev:/usr/src/dev \
 sspreitzer/shellinabox:latest
 ```
 Running terminal in a remote container and accessing it via HTTPS

``` 
docker container run --tty -d \
 --name billing \
 --read-only \
 alpine /bin/sh
 ```
Set read-only filesystem.

```
docker container ps -a \
--format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
```
Print formatted Name Image & Status.

```
docker image build -t my-centos -f Dockerfile .
```
Sending build context to Docker daemon 2.048kB
The first thing the builder does is package the files in the current build context, excluding the files and folder mentioned in the .dockerignore file (if present), and sends the resulting .tar file to the Docker daemon.

```
FROM alpine:3.7 AS build
RUN apk update && \    
apk add --update alpine-sdk
RUN mkdir /appWORKDIR /app
COPY . /appRUN mkdir bin
RUN gcc hello.c -o bin/hello 
FROM alpine:3.7COPY --from=build /app/bin/hello /app/helloCMD /app/hello
```
Multistage build. In this case it's a reduction in size by a factor of 40. A smaller image has many advantages, such as a smaller attack surface area for hackers, reduced memory and disk consumption, faster startup times of the corresponding containers, and a reduction of the bandwidth needed to download the image from a registry, such as Docker Hub.

```
-v /var/run/docker.sock:/var/run/docker.sock
```
Mounting the Docker socket into the container, so Docker can be accessed from within the container. Docker socket into the builder, the Docker commands act on the host.
It is important to note that here we are not talking about running the
Docker Engine inside the container but rather only the Docker CLI and
bind-mount the Docker socket from the host into the container so that the
CLI can communicate with the Docker Engine running on the host
computer. This is an important distinction. Running the Docker Engine
inside a container, although possible, is not recommended.

```
docker image ls --filter dangling=false --filter "reference=*/*/*:latest"
```
Filter only outputs images that are not dangling, that is, real images whose
fully qualified name is of the form <registry>/<user|org><repository>:<tag>, and
the tag is equal to latest.

```
 docker container run --rm -it \
 --name stress-test \
 --memory 512M \
 ubuntu:19.04 /bin/bash
 apt-get update && apt-get install -y stress
 stress -m 4
 ```
 Limiting resources consumed by a container
possibility of limiting the resources a single container can consume at. This includes
CPU and memory consumption. Use stress to simulate four workers, which try to malloc() memory in blocks of 256MB.
In the Terminal running Docker stats, observe how the value for MEM USAGE approaches
but never exceeds LIMIT. This is exactly the behavior we expected from Docker. Docker
uses Linux cgroups to enforce those limits.


```
docker container run --rm -it --network none alpine:latest /bin/sh
```

Sometimes, we need to run a few application services or jobs that do not need any network
connection at all to execute the task at hand. It is strongly advised that you run those
applications in a container that is attached to the none network. This container will be
completely isolated, and is thus safe from any outside access.

```
docker container run --name web -P -d nginx:alpine
```
We can let Docker decide which host port our container port shall be
mapped to. Docker will then select one of the free host ports in the range of
32xxx. This automatic mapping is done by using the `-P` parameter

When using the UDP protocol for communication over a certain port, the publish
parameter will look like `-p 3000:4321/udp`. Note that if we want to allow communication with both `TCP` and `UDP` protocols over the same port, then we have to map each protocol separately.

There is an important difference between running two containers attached to the same network and two containers running in the same network namespace. In both cases, the containers can freely communicate with each other, but in the latter case, the communication happens over localhost.
The container has its own virtual network stack, as does the host. Therefore, container ports and host ports exist completely independently and by default have nothing in common at all.



## Persistent Data
Containers are usually immutable and ephemeral
https://www.oreilly.com/ideas/an-introduction-to-immutable-infrastructure
Docker volumes are a configuration option for a container that creates a special location outside of that container's union file system to store unique data. This preserves it across container removals and allows us to attach it to whatever container we want. And the container just sees it like a local file path.
Bind mounts are simply us sharing or mounting a host directory, or file, into a container. 
 
The default volume driver is the so-called local driver, which stores the data locally in the host filesystem.

Volumes
``` Dockerfile:
...
VOLUME /var/lib/something
...
```
Volumes needs manual deletion. Use this if data is more important then container.

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
The content that is already there is replaced by the content of the host folder.


``` 
docker volume create psql-data2
docker container run -d --rm --name pg1 -v psql-data2:/var/lib/postgresql/data postgres:9.6.1
docker container stop pg1
docker container run -d --rm --name pg2 -v psql-data2:/var/lib/postgresql/data postgres:9.6.2
```


Bind Mounts
``` 
... run -v ${pwd}:/path/inside/container
```
Maps a host file or directory to a container file or directory. Two locations pointing to the same files. 
Can't use in Dockerfile, must be at container run stage.
We can define as readonly.

``` 
docker run --rm --name serv1 -p 80:80 -v ${pwd}:/site bretfisher/jekyll-serve
```

## Docker Compose
- Create one-liner developer environment startups.
- YAML fomratted.
- CLI tool docker-compose for local and testing purposes.
- Custom compose file should be used with -f flag.

``` 
   version: '3.1'  # if no version is specificed then v1 is assumed. Recommend v2 minimum

services:  # containers. same as docker run
  servicename: # a friendly name. this is also DNS name inside network
    image: # Optional if you use build:
    command: # Optional, replace the default CMD specified by the image
    environment: # Optional, same as -e in docker run
    volumes: # Optional, same as -v in docker run
  servicename2:

volumes: # Optional, same as docker volume create

networks: # Optional, same as docker network create
```


``` 
   version: '3.1'

services:
  jekyll:
    image: bretfisher/jekyll-serve
    volumes:
      - .:/site
    ports:
      - '80:4000'
```

Compose can build custom images

    
``` 
docker-compose build
```

``` 
   version: '3.1'

services:
  proxy:
    build:
      context: .
      dockerfile: nginx.Dockerfile
    ports:
      - '80:80'
```
Build custom image on docker-compose up command with ${folder_name}/proxy name

``` 
   version: '3.1'

services:
  proxy:
    build:
      context: .
      dockerfile: nginx.Dockerfile
    image: proxxy
    ports:
      - '80:80'
```
Build custom image on docker-compose up command with proxxy name

```
docker-compose config
```

Command docker-compose config shows how compose will look with the variables filled in.

```
docker-compose -f docker-compose.yml -f docker-compose-ci.yml up -d --
build
```
Using Compose overrides.


## Docker Swarm
An orchestrator is an infrastructure software that is used to run and manage containerized applications in a cluster while making sure that these applications are in their desired state at all times. 

The tasks of an orchestrator:
- Reconciling the desired state
- Replicated and global services
- Service discovery
- Routing
- Load balancing
- Scaling
- Self-healing
- Zero downtime deployments
- Affinity and location awareness
- Security
- Role-based access control (RBAC)
- Secrets
- Content trust

The architecture of a Docker Swarm from a 30,000-foot view consists of two main parts—a raft consensus group of an odd number of manager nodes, and a group of worker nodes that communicate with each other over a gossip network, also called the control plane.

There are two quite different types of services that we might want to run in a cluster that is
managed by an orchestrator. They are replicated and global services. A replicated service is a
service that is required to run in a specific number of instances, say 10. A global service, in
turn, is a service that is required to have exactly one instance running on every single
worker node of the cluster. I have used the term worker node here. In a cluster that is
managed by an orchestrator, we typically have two types of nodes, managers and workers.
A manager node is usually exclusively used by the orchestrator to manage the cluster and
does not run any other workload. Worker nodes, in turn, run the actual applications.
So, the orchestrator makes sure that, for a global service, an instance of it is running on
every single worker node, no matter how many there are. We do not need to care about the
number of instances, but only that on each node, it is guaranteed to run a single instance of
the service.
Once again, we can fully rely on the orchestrator to handle this. In a replicated service, we
will always be guaranteed to find the exact desired number of instances, while for a global
service, we can be assured that on every worker node, there will always run exactly one
instance of the service. The orchestrator will always work as hard as it can to guarantee this
desired state.

`In Kubernetes, a global service is also called a DaemonSet.`

Each Docker Swarm needs to include at least one manager node. For high availability reasons, we should have more than one manager node in a Swarm. This is especially true for production or production-like environments. If we have more than one manager node, then these nodes work together using the Raft consensus protocol. The `Raft` consensus protocol is a standard protocol that is often used when multiple entities need to work together and always need to agree with each other as to which activity to execute next.

The manager nodes are not only responsible for managing the Swarm but also for
maintaining the state of the Swarm. What do we mean by that? When we talk about the state of the Swarm we mean all of the information about it—for example, how many nodes are in the Swarm and what are the properties of each node, such as name or IP address. We also mean what containers are running on which node in the Swarm and more. What, on the other hand, is not included in the state of the Swarm is data produced by the application services running in containers on the Swarm. This is called application data and is definitely not part of the state that is managed by the manager nodes.

All of the Swarm states are stored in a high-performance key-value store (kv-store) on each manager node. That's right, each manager node stores a complete replica of the whole Swarm state. This redundancy makes the Swarm highly available. If a manager node goes down, the remaining managers all have the complete state at hand.

Worker nodes communicate with each other over the so-called control plane. They use the gossip protocol for their communication. This communication is asynchronous, which means that, at any given time, it is likely that not all worker nodes are in perfect sync. 

It is mostly information that is needed for service discovery and routing, that is, information about which containers are running on with nodes and more

`Swarm` is a clustering solution build inside Docker
Control Plane is how orders get sent around the Swarm.
A single service can have multiple tasks and each one of those tasks will launch a container.
``` 
docker service create
```
 On Manager Node
- API           Accept command from client and creates service object
- Orchestrator  Reconcillaion loop for service  objects and create tasks
- Allocator     Allocates IP addresses to tasks
- Scheduler     Assign nodes to tasks
- Dispatcher    Check in on workers
On Worker node
- workers       Connects to dispatcher to check on assigned tasks
- Executor      Executes tasks assigned to worker node

### Services
A Swarm service is an abstract thing. It is a description of the desired state of an application
or application service that we want to run in a Swarm. The Swarm service is like a manifest
describing such things as the following:
Name of the service
Image from which to create the containers
Number of replicas to run
Network(s) that the containers of the service are attached to
Ports that should be mapped

### Task
Service corresponds to a description of the desired state in which an application service should be at all times. Part of that description was the number of replicas the service should be running. Each replica is represented by a task. In this regard,
a Swarm service contains a collection of tasks. On Docker Swarm, a task is the atomic unit of deployment. Each task of a service is deployed by the Swarm scheduler to a worker node. The task contains all of the necessary information that the worker node needs to run a
container based on the image, which is part of the service description. Between a task and a container, there is a one-to-one relation. The container is the instance that runs on the worker node, while the task is the description of this container as a part of a Swarm service.

``` 
docker swarm init
```
- Creates Root Signing Certificate created for Swarm
- Certificate is issued for first Manager node
- Join tokens are created
Raft Consensus Database is created to store CA, configs and secrets.
Protocol to ensure consistency between nodes. I created database on disc, and stores the configuration of the Swarm.


``` 
docker node ls
```
Docker node ## can promote workers to managers and demoting them.

``` 
docker service create slpine ping 8.8.8.8
```
Returns service ID, with one replica and random name.

``` 
docker service ps <service_name>
```
Can see which node was applied.

``` 
docker serivce update <id> --replicas 3
```
Scalle up to 3 replicas.


``` 
docker update
```
Allow to update certain variable on running container without kill or restart


``` 
docker service rm <service_name>
docker container ls
```
Removing service


Creating multinode Swarm
``` 
    1) node1: docker swarm init 

    2) node1: docker swarm init --advertise-addr <IP>

    3) [Copy generated command, and paste in other machine]
    node2: docker swarm join --token <TOKEN> <IP>
    After that this node is a part of swarm as worker

    1) node1: docker node ls

    2) node2: docker node ls
    Command won't work, because docker worker aren't privalage don't have access to controll swarm.

    1) node1: docker node update --role manager node2
    * node thats we currentyly taliking to

    1) node1: docker node ls
    node is considered [MANAGER STATUS] as Reachable

    1) [Add node3 add as manager by default]
    [Copy generated command, and paste in node3]
    node1: docker swarm join-token manager
    We can get token at any time, don't need to story anywhere

    1) node3: docker swarm join --token <TOKEN> <IP>

    2)  node1: docker service create --replicas 3 alpine ping 8.8.8.8

    3)  node1:  docker node ps
    node1: docker node ps node2

    1)  node1: docker service ps <service_name>
```

## Scalling Out with Overlay Networking
 
New networking Swarm driver: overlay

``` 
docker network create --driver overlay
```
Swarm wide bridge network, where containers accros hosts on same virt network can access each other
optional IPSec (AES) encryption, off by default
Each service can be conected to multiple networks

``` 
   node1: docker network create --driver overlay my_network
   node1: docker network ls
   node1: docker service create --name psql --network my_network -e POSTGRES_PASSWORD=example postgres
   node1: docker service ls 
   node1: docker service ps psql
   node1: dokcer container logs psql..
   docker service create --name drupal -p 80:80 --network my_net drupal
```
Overlay network acts as like everything's on the same subnet.

## Swarm Routing Mesh, global trafiic router 
Incoming ingress network that distribute packets for service to the tasks fot that service.
Span all nodes in Swarm, uses IPVS from Linux Kernel.
Load balancing across all the nodes and listening on all the nodes for traffic.

If we have 3 nodes with 2 replicas, every node has built-in load balancer on thier external IP address. 
Any traffic that comes in to any of these three nodes hits load balancer on published port, then Load Balancer decides which container should get traffic and whether or not that traffic is on local node, or it needs to send the traffic over the network, to a different node. 
In swarm we can only use overlay network.

``` 
   docker service create --name seach  --replicas 3 -p 9200:9200 elasticsearch:2
   curl localhost:9200
```
Routing mesh 17.0.3 routing mesh i load balancer are stateles balancer.
LB is at OSI Layer 3 (TCP)
Nginx or HAProxy  LB proxy, statfull balancer- allows caching.

% Creating voting app %
``` 
   docker network create --driver overlay frontend
   docker network create --driver overlay backend
   docker network volume create volume1

   docker service create --name worker  --network backend --network frontend dockersamples/examplevotingapp_worker
   
   docker service create --name redis --network frontend redis:3.2

   docker service create --name db --network backend --mount type=volume,source=volume1,target=/var/lib/postgresql/data postgres:9.4

   docker service create --name vote --replicas 2 -p 80:80 --network frontend dockersamples/examplevotingapp_vote:before

   docker service create --name result --replicas 1 --network backend dockersamples/examplevotingapp_result:before


   docker service logs worker
   docker service logs result
```

### Stacks - Compose files for production Swarm

A stack is used to describe a collection of Swarm services that are
related, most probably because they are part of the same application.
`Overlay` network allows
containers attached to the same overlay network to discover each other and freely communicate with each other.

``` 
   docker stack deploy
```
Stacks manages all those objects for us , including overlay network per stack. Adds stack name to start of their name.

``` 
   new deploy: key in compose file
```
Can't do build using Stack.
On local compose ignores deployinformation.  
Swarm on production ignores build.

``` 
   docker stack deploy -c compose-stack.yml voteapp
```
Version 3+ is needed in compose in order to use Stacks.

``` 
   docker stack ps voteapp
```


``` 
   docker stack services voteapp
```

## Secrets Storage

Secrets can be created by authorized or trusted
personnel. The values of those secrets are then encrypted and stored in the highly available cluster state database. The secrets, since they are encrypted, are now secure at rest. Once a secret is requested by an authorized application service, the secret is only forwarded to the
cluster nodes that actually run an instance of that particular service, and the secret value is never stored on the node but mounted into the container in a tmpfs RAM-based volume.
Only inside the respective container is the secret value available in clear text

Secrets are first stored in Swarm , then assigned to a service(s).
Only containers in assigned Service(s) can see them.
Secrets depends on swarm.
Supports generic strings or binary content up to 500Kb in size.

``` 
    docker secret create XXX abc.txt
    docker secret ls

    echo "myPassword" | docker secret create create XXX -
    docker secret inspect XXX

    docker service create --name pgsql --secret XXX --secret pg_user -e POSTGRES_PASSWORD_FILE=/run/secrets/XXX
```

``` 
   docker service update --secret-rm
```
Removing secret, redeploy container.


``` 
    version: "3.1"

    services:
      psql:
        image: postgres
        secrets:
          - psql_user
          - psql_password
        environment:
          POSTGRES_PASSWORD_FILE: /run/secrets/psql_password
          POSTGRES_USER_FILE: /run/secrets/psql_user

    secrets:
      psql_user:
        file: ./psql_user.txt
      psql_password:
        file: ./psql_password.txt


```
Version has to be 3.1 in order to se secrets with Stack.
``` 
   docker stack deploy -c compose.yml <service_name>
```
Use secrets with Swarm Stacks.

``` 
   docker service update --image myapp:1.2.1 <service_name>
```
Update image to a newer version. 

``` 
   docker service update --env-add NODE=producion --publish-rm 8080 <service_name>
```
Update environmental variable & remove published port.

``` 
   docker service scale web=8 api=6
```
Changing number of replicas. Can apply to number of services.


``` 
   docker service update --publish-rm 8080 --publish-radd 8992 <service_name>
```
"Update" port number of service.

``` 
   docker service update --force <service_name>
```
Replace the tasks.

``` 
   
```
Healthchecks are supported in Dockerfile, Compose YAML, docker run and Swarm Services.
Docker engine will exec's the command in the container - like curl localhost.
Three container states: starting, healthy, unhealthy.
Services will replace tasks if they fail healthcheck.

``` 
       docker run \
       --health-cmd="curl -f localhost:9200/_cluster/health || false" \
       --health-interval=5s \
       --health-retries=3 \
       --health-timeout=2s \
       --health-start-period=15s \
       elasticsearch:2
```
Perform healthcheck on existing image that doesn't have healtcheck in it.

``` 
   version: "2.1"
   services:
      web:
      image: nginx
      healthcheck:
        test: ["CMD", "curl", "-f","http://localhost"]
        interval: 1m30s
        timeout: 10s
        retries: 3
        start_period: 1m
```
Healthcheck in Compose file.

``` 
     docker container run --name pg -d --health-cmd="pg_isready -U postgres || exit 1" postgres && docker container ls
```
Healthcheck with docker run command.

``` 
    docker service create --name pg --health-cmd="pg_isready -U postgres" postgres     
```
Healthcheck with swarm service command.

``` 
    docker container run -d -p 5000:5000 --name registry registry

```
Run registry image

``` 
    docker tag hello-world 127.0.0.1:5000/hello-world
    docker push 127.0.0.1:5000/hello-world
```
Re-tag an existing image an push it to new registry

``` 
    docker image remove hello-world
    docker image remove  127.0.0.1:5000/hello-world
    docker pull 127.0.0.1:5000/hello-world
```
Remove image from local cache and oull from new repository

Web UI's:
``` 
    docker run -d -p 10086:10086 -v /var/run/docker.sock:/var/run/docker.sock tobegit3hub/seagull
```
Seagull

``` 
    docker run -dit -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer
```
Visualizer

``` 
    docker run -dti --restart always --name container-web-tty \
    -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    wrfly/container-web-tty
```
Container-web-tty

``` 
     docker run -dti --restart always --name portainer \
    -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    portainer/portainer
```
Portainer

``` 
     docker run -d -p 8080:8080 -p 80:80 \
    -v $PWD/traefik.toml:/etc/traefik/traefik.toml traefik:v2.0
```
Traefik

Instead of using wget in Dockerfile, we can ADD command  (docker internal tool to downlaod file). 


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
- Autopilot Pattern Applications
- Alternative to Docker is Rkt


## Authors

* **Piotr Wera** - *Initial work* - [pwera](https://github.com/pwera)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

