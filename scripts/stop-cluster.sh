#!/usr/bin/env bash
set -euo pipefail

if [ -z "${HADOOP_HOME:-}" ]; then
  export HADOOP_HOME=/opt/hadoop
fi

"$HADOOP_HOME/sbin/stop-yarn.sh"
"$HADOOP_HOME/sbin/stop-dfs.sh"
