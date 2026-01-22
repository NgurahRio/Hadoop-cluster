#!/usr/bin/env bash
set -euo pipefail

if [ -z "${HADOOP_HOME:-}" ]; then
  export HADOOP_HOME=/opt/hadoop
fi

BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"
WORKERS_FILE="$BASEDIR/conf/workers"

jps

if [ -f "$WORKERS_FILE" ]; then
  while IFS= read -r host; do
    [ -z "$host" ] && continue
    echo "== $host =="
    ssh "$host" jps
  done < "$WORKERS_FILE"
fi

hdfs dfsadmin -report

yarn node -list
