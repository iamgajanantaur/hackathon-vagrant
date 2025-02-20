#!/bin/bash
sudo useradd -m -s /bin/bash hduser
echo "hduser:test" | sudo chpasswd
sudo usermod -aG sudo hduser
echo "hduser ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/hduser
sudo su - hduser
sudo apt update
sudo apt install vim ssh sshpass net-tools openjdk-8-jdk git -y
cd ~
wget http://172.18.4.76/hadoop-3.3.2.tar.gz
tar xvf hadoop-3.3.2.tar.gz
sudo tee -a /etc/hosts > /dev/null <<EOF
192.168.80.100  master
192.168.80.101  worker1
192.168.80.102  worker2
192.168.80.103  worker3
EOF
cat <<EOF >> ~/.bashrc
# Hadoop and Java environment variables
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=\$HOME/hadoop-3.3.2
export PATH=\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin:\$PATH
EOF
source ~/.bashrc
