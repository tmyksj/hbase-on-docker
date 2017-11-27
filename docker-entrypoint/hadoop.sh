#!/bin/bash

source /docker-entrypoint/common/args-utils.sh
source /docker-entrypoint/common/config-utils.sh

copy-config .ssh
service ssh restart

copy-config hadoop ${HADOOP_HOME}

if [ -f /docker-entrypoint/first-run ]; then
  rm /docker-entrypoint/first-run

  if args-contains namenode; then ${HADOOP_HOME}/bin/hdfs namenode -format; fi
  if args-contains secondarynamenode; then ${HADOOP_HOME}/bin/hdfs secondarynamenode -format; fi
fi

if args-contains datanode; then ${HADOOP_HOME}/bin/hdfs --daemon start datanode; fi
if args-contains historyserver; then ${HADOOP_HOME}/bin/mapred --daemon start historyserver; fi
if args-contains namenode; then ${HADOOP_HOME}/bin/hdfs --daemon start namenode; fi
if args-contains nodemanager; then ${HADOOP_HOME}/bin/yarn --daemon start nodemanager; fi
if args-contains proxyserver; then ${HADOOP_HOME}/bin/yarn --daemon start proxyserver; fi
if args-contains resourcemanager; then ${HADOOP_HOME}/bin/yarn --daemon start resourcemanager; fi
if args-contains secondarynamenode; then ${HADOOP_HOME}/bin/hdfs --daemon start secondarynamenode; fi

stop-docker() {
  if args-contains datanode; then ${HADOOP_HOME}/bin/hdfs --daemon stop datanode; fi
  if args-contains historyserver; then ${HADOOP_HOME}/bin/mapred --daemon stop historyserver; fi
  if args-contains namenode; then ${HADOOP_HOME}/bin/hdfs --daemon stop namenode; fi
  if args-contains nodemanager; then ${HADOOP_HOME}/bin/yarn --daemon stop nodemanager; fi
  if args-contains proxyserver; then ${HADOOP_HOME}/bin/yarn --daemon stop proxyserver; fi
  if args-contains resourcemanager; then ${HADOOP_HOME}/bin/yarn --daemon stop resourcemanager; fi
  if args-contains secondarynamenode; then ${HADOOP_HOME}/bin/hdfs --daemon stop secondarynamenode; fi
  exit 0
}

trap "stop-docker" HUP INT QUIT TERM
while true; do sleep 1; done
