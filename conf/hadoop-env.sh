#!/usr/bin/env bash
# Hadoop environment overrides for cluster
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export HADOOP_HOME=/home/riyo/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_LOG_DIR=/home/riyo/hadoop/logs

# JMX Exporter for Prometheus (ports: 7001-7005)
export JMX_EXPORTER_JAR=$HADOOP_HOME/jmx/jmx_prometheus_javaagent-0.20.0.jar
export HADOOP_NAMENODE_OPTS="$HADOOP_NAMENODE_OPTS -javaagent:$JMX_EXPORTER_JAR=7001:$HADOOP_CONF_DIR/jmx-nn.yaml"
export HADOOP_DATANODE_OPTS="$HADOOP_DATANODE_OPTS -javaagent:$JMX_EXPORTER_JAR=7002:$HADOOP_CONF_DIR/jmx-dn.yaml"
export YARN_RESOURCEMANAGER_OPTS="$YARN_RESOURCEMANAGER_OPTS -javaagent:$JMX_EXPORTER_JAR=7003:$HADOOP_CONF_DIR/jmx-rm.yaml"
export YARN_NODEMANAGER_OPTS="$YARN_NODEMANAGER_OPTS -javaagent:$JMX_EXPORTER_JAR=7004:$HADOOP_CONF_DIR/jmx-nm.yaml"
export MAPRED_HISTORYSERVER_OPTS="$MAPRED_HISTORYSERVER_OPTS -javaagent:$JMX_EXPORTER_JAR=7005:$HADOOP_CONF_DIR/jmx-hs.yaml"
