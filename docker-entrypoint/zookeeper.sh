#!/bin/bash

source /docker-entrypoint/common/args-utils.sh
source /docker-entrypoint/common/config-utils.sh

copy-config .ssh
service ssh restart

copy-config zookeeper ${ZOOKEEPER_HOME}

if [ -f /docker-entrypoint/first-run ]; then
  rm /docker-entrypoint/first-run

  mkdir ${1}
  echo ${2} > ${1}/myid
fi

${ZOOKEEPER_HOME}/bin/zkServer.sh start

stop-docker() {
  ${ZOOKEEPER_HOME}/bin/zkServer.sh stop
  exit 0
}

trap "stop-docker" HUP INT QUIT TERM
while true; do sleep 1; done
