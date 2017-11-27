#!/bin/bash

args=${@}

args-contains() {
  for arg in ${args}; do
    if [ ${arg} = ${1} ]; then
        return 0
    fi
  done

  return 1
}
