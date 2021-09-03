#!/usr/bin/env bash

set -e

STACK_NAME="project"
DOCKER_COMPOSE_FILE="${STACK_NAME}-control-center.yml"

help() {
  echo
  echo "\
Usage: ./setup.sh start                      Starts a stack
       ./setup.sh status                     Is any of ml-project stack services running.
       ./setup.sh stop                       it stops and removes the stack
       ./setup.sh update_service service     Forces update of a given service"
  echo
}

start() {
  if docker stack ps ${STACK_NAME} >/dev/null 2>&1; then
    logger "Stack is already running..."
    exit 1
  fi
  pull_images
  deploy
}

stop() {
  if docker stack ps ${STACK_NAME} >/dev/null 2>&1; then
    docker stack rm ${STACK_NAME} >/dev/null 2>&1;
    logger "Stack is removed successfully"
    exit 1
  else
    logger "Stack is not running..."
    exit 1
  fi
}


pull_images() {
    #Downloading Images from Repository
    imageNames=$(grep -F "image: " *.yml | grep -Fv "#" | awk '{print $3}')
    logger "All images being downloaded are: \n${imageNames}"
    for imageName in $imageNames; do
        logger "Pulling image from artifactory: $imageName"
    local image="$(echo -e "${imageName}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    logger $(docker image pull $image)
    done
    sleep 5
}

status() {
    if docker stack ps ${STACK_NAME} >/dev/null 2>&1; then
        logger "Stack is running..."
        exit 1
    else
        logger "Stack is not running..."
        exit 1
    fi
}

deploy() {
  logger "Deploying stack..."
  docker stack deploy --compose-file ${DOCKER_COMPOSE_FILE} --with-registry-auth ${STACK_NAME}
  sleep 3
  logger "Deployed stack successfully"
  sleep 3
}

update_service() {
  SERVICE_NAME=$1
  SERVICE_WITH_IMAGE=$(docker stack services ${STACK_NAME} --format "{{.Name}};{{.Image}}" --filter="name=${STACK_NAME}_${SERVICE_NAME}")
}

logger() {
  echo -e "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $*" 2>&1 | tee -a "${UPDATE_LOG}.txt"
}

case $1 in
start)
  start
  ;;
status)
  status
  ;;
update_service)
  update_service "$2"
  ;;
stop)
  stop
  ;;
*)
  help
  ;;
esac

exit 0
