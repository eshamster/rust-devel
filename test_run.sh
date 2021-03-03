#!/bin/bash

set -eu

volume=${1:-~/work/rust}

if [ ! -d ${volume} ]; then
  echo "${volume} is not exist" 1>&2
  exit 1
fi

name=rust-devel

docker rmi $(docker images | awk '/^<none>/ { print $3 }') || echo "ignore rmi error"
docker rm `docker ps -a -q` || echo "ignore rm error"

docker build -t ${name}:latest .
docker run --name ${name} -v ${volume}:/root/work -it ${name}:latest /bin/bash
