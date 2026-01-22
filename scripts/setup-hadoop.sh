#!/usr/bin/env bash
set -euo pipefail

HADOOP_VERSION="3.3.6"
HADOOP_TGZ="hadoop-$HADOOP_VERSION.tar.gz"
HADOOP_URL="https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/$HADOOP_TGZ"

sudo mkdir -p /opt

if [ ! -d "/opt/hadoop-$HADOOP_VERSION" ]; then
  if [ ! -f "/tmp/$HADOOP_TGZ" ]; then
    curl -fL "$HADOOP_URL" -o "/tmp/$HADOOP_TGZ"
  fi
  sudo tar -xzf "/tmp/$HADOOP_TGZ" -C /opt
fi

if [ -L "/opt/hadoop" ]; then
  sudo rm -f /opt/hadoop
fi
if [ ! -e "/opt/hadoop" ]; then
  sudo ln -s "/opt/hadoop-$HADOOP_VERSION" /opt/hadoop
fi

PROFILE_FILE="/etc/profile.d/hadoop.sh"
if [ ! -f "$PROFILE_FILE" ] || ! grep -q "HADOOP_HOME" "$PROFILE_FILE"; then
  sudo tee "$PROFILE_FILE" >/dev/null <<EOF
export HADOOP_HOME=/opt/hadoop
export PATH=\$PATH:/opt/hadoop/bin:/opt/hadoop/sbin
export HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
EOF
fi

sudo mkdir -p /var/lib/hadoop/hdfs/namenode
sudo mkdir -p /var/lib/hadoop/hdfs/datanode
sudo mkdir -p /var/lib/hadoop/tmp
sudo mkdir -p /var/log/hadoop

sudo chown -R "$USER":"$USER" /var/lib/hadoop /var/log/hadoop

BASEDIR="$(cd "$(dirname "$0")/.." && pwd)"
if [ -d "$BASEDIR/conf" ]; then
  sudo rsync -a "$BASEDIR/conf/" /opt/hadoop/etc/hadoop/
fi

echo "Hadoop $HADOOP_VERSION installed to /opt/hadoop"
