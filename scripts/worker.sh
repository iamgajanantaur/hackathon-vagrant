#!/bin/bash
sudo useradd -m -s /bin/bash hduser
echo "hduser:test" | sudo chpasswd
sudo usermod -aG sudo hduser
echo "hduser ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/hduser
sudo -u hduser bash <<EOF
sudo apt update
sudo apt install vim ssh net-tools openjdk-8-jdk git -y
cd ~
wget http://172.20.10.2/hadoop-3.3.2.tar.gz
# https://archive.apache.org/dist/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz
tar xvf hadoop-3.3.2.tar.gz

# Update /etc/hosts
sudo tee -a /etc/hosts > /dev/null <<EOL
192.168.10.112  master
192.168.10.113  worker1
192.168.10.102  worker2
192.168.10.103  worker3
EOL
# Configure environment variables
cat <<EOL >> ~/.bashrc
# Hadoop and Java environment variables
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=\$HOME/hadoop-3.3.2
EOL
source ~/.bashrc
echo "export PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH" >> .bashrc
source ~/.bashrc

# Clone the Hadoop cluster setup repo
git clone https://github.com/nilesh-g/hadoop-cluster-install.git
cp hadoop-cluster-install/worker/* hadoop-3.3.2/etc/hadoop/
EOF
