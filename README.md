# project-setup
This package will help us to set up project service environment and its dependencies

# prerequisite 
**docker** should up and run on your system 

#steps to start 
please execute **setup.sh** 

Usage:

       ./setup.sh start                      Starts a stack

       ./setup.sh status                     Is any of ml-project stack services running.

       ./setup.sh stop                       it stops and removes the stack

       ./setup.sh update_service service     Forces update of a given service


**Note:**

if you get "this node is not a swarm manager. Use "docker swarm init" or "docker swarm join" to connect this node to swarm and try again" error,
please execute "**docker swarm init**".
This script will download the image automatically from the docker hug and start the services for us.

Topics should be created to start the application

**kafka-topics --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic PublishProject**
