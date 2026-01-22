#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"
CONF_DIR="$BASEDIR/conf"
WORKERS_FILE="$CONF_DIR/workers"

if [ ! -f "$WORKERS_FILE" ]; then
  echo "Missing workers file at $WORKERS_FILE" >&2
  exit 1
fi

while IFS= read -r host; do
  [ -z "$host" ] && continue
  echo "Pushing config to $host"
  rsync -avz --delete "$CONF_DIR/" "$host:/opt/hadoop/etc/hadoop/"
done < "$WORKERS_FILE"
