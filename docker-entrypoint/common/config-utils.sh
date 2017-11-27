#!/bin/bash

copy-config() {
  if [ ${1} = ".ssh" -a -d /docker-config/.ssh ]; then
    if [ ! -d /root/.ssh ]; then
      mkdir /root/.ssh
    fi

    cp -r /docker-config/.ssh/* /root/.ssh
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/config
    chmod 600 /root/.ssh/id_rsa
    chmod 644 /root/.ssh/id_rsa.pub
  elif [ -d /docker-config/${1} ]; then
    cp -r /docker-config/${1}/* ${2}
  fi
}
