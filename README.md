# Hadoop Cluster Template

Template konfigurasi Hadoop 3.3.x untuk topologi 1 master + 5 worker (Ubuntu 22.04).

## 1) Set hostname dan /etc/hosts
Di setiap node:

```bash
sudo hostnamectl set-hostname master
# atau: worker1, worker2, worker3, worker4, worker5
```

Isi `/etc/hosts` di semua node:

```text
<IP_MASTER>  master
<IP_W1>      worker1
<IP_W2>      worker2
<IP_W3>      worker3
<IP_W4>      worker4
<IP_W5>      worker5
```

Contoh `~/.ssh/config` di laptop (untuk VSCode Remote SSH):

```sshconfig
Host master
  HostName <IP_MASTER>
  User <LAB_USER>
  IdentityFile ~/.ssh/id_ed25519

Host worker1
  HostName <IP_W1>
  User <LAB_USER>
  IdentityFile ~/.ssh/id_ed25519

Host worker2
  HostName <IP_W2>
  User <LAB_USER>
  IdentityFile ~/.ssh/id_ed25519

Host worker3
  HostName <IP_W3>
  User <LAB_USER>
  IdentityFile ~/.ssh/id_ed25519

Host worker4
  HostName <IP_W4>
  User <LAB_USER>
  IdentityFile ~/.ssh/id_ed25519

Host worker5
  HostName <IP_W5>
  User <LAB_USER>
  IdentityFile ~/.ssh/id_ed25519
```

## 2) Setup SSH tanpa password (dari master ke semua worker)
Di master:

```bash
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
for h in worker1 worker2 worker3 worker4 worker5; do
  ssh-copy-id "$h"
done
```

Uji koneksi tanpa password:

```bash
for h in worker1 worker2 worker3 worker4 worker5; do
  ssh "$h" hostname
done
```

## 3) Jalankan script setup
Salin folder `hadoop-cluster/` ke semua node (atau clone repo), lalu jalankan:

Di semua node:

```bash
cd hadoop-cluster
bash scripts/setup-java.sh
bash scripts/setup-hadoop.sh
```

Di master:

```bash
bash scripts/push-config.sh
```

## 4) Format namenode (sekali di master)

```bash
/opt/hadoop/bin/hdfs namenode -format
```

## 5) Start cluster
Di master:

```bash
bash scripts/start-cluster.sh
```

## 6) Test HDFS

```bash
/opt/hadoop/bin/hdfs dfs -mkdir -p /user/$USER
/opt/hadoop/bin/hdfs dfs -put /etc/hosts /user/$USER/
/opt/hadoop/bin/hdfs dfs -ls /user/$USER
```

## 7) Test MapReduce wordcount

```bash
/opt/hadoop/bin/hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount /user/$USER/hosts /user/$USER/wordcount-out
/opt/hadoop/bin/hdfs dfs -cat /user/$USER/wordcount-out/part-r-00000 | head
```

## 8) Health check

```bash
bash scripts/health-check.sh
```
