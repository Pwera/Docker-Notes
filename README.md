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

## Docker Swarm
Swarm is a clustering solution build inside Docker
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

    4) node1: docker node ls

    5) node2: docker node ls
    Command won't work, because docker worker aren't privalage don't have access to controll swarm.

    6) node1: docker node update --role manager node2
    * node thats we currentyly taliking to

    7) node1: docker node ls
    node is considered [MANAGER STATUS] as Reachable

    8) [Add node3 add as manager by default]
    [Copy generated command, and paste in node3]
    node1: docker swarm join-token manager
    We can get token at any time, don't need to story anywhere

    9) node3: docker swarm join --token <TOKEN> <IP>

    10) node1: docker service create --replicas 3 alpine ping 8.8.8.8

    11) node1:  docker node ps
    node1: docker node ps node2

    12) node1: docker service ps <service_name>
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

## Stacks - Compose files for production Swarm

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

``` 
    docker run -dit -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer
```

``` 
    docker run -dti --restart always --name container-web-tty \
    -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    wrfly/container-web-tty
```

``` 
     docker run -dti --restart always --name portainer \
    -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    portainer/portainer
```

(96)


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

