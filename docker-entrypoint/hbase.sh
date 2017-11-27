#!/bin/bash

source /docker-entrypoint/common/args-utils.sh
source /docker-entrypoint/common/config-utils.sh

copy-config .ssh
service ssh restart

copy-config hbase ${HBASE_HOME}

if [ -f /docker-entrypoint/first-run ]; then
  rm /docker-entrypoint/first-run
fi

if args-contains master; then
  ${HBASE_HOME}/bin/start-hbase.sh
fi

stop-docker() {
  if args-contains master; then
    ${HBASE_HOME}/bin/stop-hbase.sh
  fi

  exit 0
}

trap "stop-docker" HUP INT QUIT TERM
while true; do sleep 1; done
