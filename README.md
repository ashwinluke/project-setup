# project-setup
This package will help us to set up kafka, elasticsearch, mariadb, project-service and project-search-service environment and its dependencies

# prerequisite 
**docker** should up and run on your system 

#steps to start 
Checkout the branch and execute **setup.sh** (./setup.sh start)

Usage:

       ./setup.sh start                      Starts a stack

       ./setup.sh status                     Is any of ml-project stack services running.

       ./setup.sh stop                       it stops and removes the stack

       ./setup.sh update_service service     Forces update of a given service

If the stack is up and running, 

    docker stack ls
    NAME      SERVICES   ORCHESTRATOR
    project   6          Swarm

To verify the running services 

    docker service ls
    ID             NAME                             MODE         REPLICAS   IMAGE                                                 PORTS
    ev91gcfv5p9l   project_db                       replicated   1/1        mariadb:10.3.5                                        *:3306->3306/tcp
    2ivw00d38l4b   project_elastic-search           replicated   1/1        docker.elastic.co/elasticsearch/elasticsearch:7.2.0   *:9200->9200/tcp
    m8pg4x48pmor   project_kafka                    replicated   1/1        confluentinc/cp-kafka:5.3.1                           *:9092->9092/tcp
    ra12sk1mzmpm   project_project-search-service   replicated   1/1        santhoshas1990/project-search-service:latest          *:4203->4203/tcp
    i5tzki9z3ytr   project_project-service          replicated   1/1        santhoshas1990/project-service:latest                 *:4202->4202/tcp
    6awwjg9a9vm9   project_zookeeper                replicated   1/1        confluentinc/cp-zookeeper:5.3.1                       *:12181->12181/tcp



**Note:**

you might need to add host entries to access project-service and project-search-service

if you get "this node is not a swarm manager. Use "docker swarm init" or "docker swarm join" to connect this node to swarm and try again" error,
please execute "**docker swarm init**".
This script will download the image automatically from the docker hug and start the services for us.

Topics should be created to start the application

**kafka-topics --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic PublishProject**
