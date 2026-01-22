#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "$0")" && pwd)"
out_dir="${1:-$HOME/hdfs-input}"
hdfs_dir="${2:-}"
"$BASEDIR/generate-small-files.sh" 100000 1 8 "$out_dir" "$hdfs_dir"
