#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "apt-get not found. This script expects Ubuntu." >&2
  exit 1
fi

if ! java -version >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y openjdk-11-jdk
fi

JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-amd64"
if [ ! -d "$JAVA_HOME_PATH" ]; then
  echo "JAVA_HOME not found at $JAVA_HOME_PATH" >&2
  exit 1
fi

PROFILE_FILE="/etc/profile.d/hadoop-java.sh"
if [ ! -f "$PROFILE_FILE" ] || ! grep -q "JAVA_HOME" "$PROFILE_FILE"; then
  echo "export JAVA_HOME=$JAVA_HOME_PATH" | sudo tee "$PROFILE_FILE" >/dev/null
fi

sudo update-alternatives --set java "$JAVA_HOME_PATH/bin/java" >/dev/null 2>&1 || true

echo "Java installed and JAVA_HOME set to $JAVA_HOME_PATH"
