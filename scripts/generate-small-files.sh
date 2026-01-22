#!/usr/bin/env bash
set -euo pipefail

count="${1:-}"
min_kb="${2:-}"
max_kb="${3:-}"
out_dir="${4:-$HOME/hdfs-input}"
hdfs_dir="${5:-}"

if [ -z "$count" ] || [ -z "$min_kb" ] || [ -z "$max_kb" ]; then
  echo "Usage: $0 <count> <min_kb> <max_kb> [out_dir] [hdfs_dir]" >&2
  exit 1
fi

if [ "$min_kb" -lt 1 ] || [ "$max_kb" -lt "$min_kb" ]; then
  echo "Invalid size range: min_kb=$min_kb max_kb=$max_kb" >&2
  exit 1
fi

mkdir -p "$out_dir"

width=${#count}
for i in $(seq 1 "$count"); do
  size_kb=$(( (RANDOM % (max_kb - min_kb + 1)) + min_kb ))
  size_bytes=$(( size_kb * 1024 ))
  file="$out_dir/file_$(printf "%0${width}d" "$i").bin"
  head -c "$size_bytes" /dev/urandom > "$file"
done

echo "Generated $count files in $out_dir (size ${min_kb}KB..${max_kb}KB)"

if [ -n "$hdfs_dir" ]; then
  if ! command -v hdfs >/dev/null 2>&1; then
    echo "hdfs CLI not found; cannot upload to HDFS" >&2
    exit 1
  fi
  hdfs dfs -mkdir -p "$hdfs_dir"
  hdfs dfs -put -f "$out_dir"/* "$hdfs_dir"/
  echo "Uploaded to HDFS at $hdfs_dir"
fi
