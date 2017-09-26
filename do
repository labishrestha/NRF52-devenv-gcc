#!/bin/bash

IMAGE="devenv-image"
CONTAINER="devenv-container"
RCFILE="rcfile.docker"
# Current folder is mapped into /root/(currentfoldername) in container
VIRTUALPATH="/root/${PWD##*/}"

if [[ "$1" == "up" ]]; then
#if image doesnt exist, build it then run it
  if [[ "$(docker images -q $IMAGE 2> /dev/null)" == "" ]]; then
    docker build . -t $IMAGE
  fi

elif [[ "$1" == "bash" ]]; then
  docker run -it --name $CONTAINER \
    --rm --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v $(pwd):$VIRTUALPATH \
    -w $VIRTUALPATH \
    $IMAGE /bin/bash --rcfile $RCFILE

#This only works runs inside the container
elif [[ "$1" == "_dockerbuild" ]]; then
  source $RCFILE
  ./build.sh "${@:2}"

else
  docker run -td --name $CONTAINER \
    --rm --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v $(pwd):$VIRTUALPATH \
    -w $VIRTUALPATH \
    $IMAGE
  docker exec $CONTAINER ./do _dockerbuild "${@:1}"
  docker stop $CONTAINER
fi
