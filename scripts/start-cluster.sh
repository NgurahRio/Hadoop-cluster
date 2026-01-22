#!/usr/bin/env bash
set -euo pipefail

if [ -z "${HADOOP_HOME:-}" ]; then
  export HADOOP_HOME=/opt/hadoop
fi

"$HADOOP_HOME/sbin/start-dfs.sh"
"$HADOOP_HOME/sbin/start-yarn.sh"
