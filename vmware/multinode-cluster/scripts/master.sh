#!/bin/bash
sudo useradd -m -s /bin/bash hduser
echo "hduser:test" | sudo chpasswd
sudo usermod -aG sudo hduser
echo "hduser ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/hduser
sudo -u hduser bash <<EOF
sudo apt update
sudo apt install vim ssh sshpass net-tools openjdk-8-jdk git -y
cd ~
wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz
tar xvf hadoop-3.3.2.tar.gz

# Update /etc/hosts
sudo tee -a /etc/hosts > /dev/null <<EOL
192.168.10.100  master
192.168.10.101  worker1
192.168.10.102  worker2
192.168.10.103  worker3
EOL
sudo sed -i '/^127.0.2.1 master master/d' /etc/hosts
cat <<EOL >> ~/.bashrc
# Hadoop and Java environment variables
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=\$HOME/hadoop-3.3.2
EOL
source ~/.bashrc
echo "export PATH=/home/hduser/hadoop-3.3.2/sbin:/home/hduser/hadoop-3.3.2/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

git clone https://github.com/nilesh-g/hadoop-cluster-install.git
ls -l
pwd
cp hadoop-cluster-install/master/* hadoop-3.3.2/etc/hadoop/
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa -q
sshpass -p 'test' ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hduser@master
sshpass -p 'test' ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hduser@worker1
sshpass -p 'test' ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hduser@worker2
sshpass -p 'test' ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hduser@worker3
EOF
echo "**********************************************************************************************"
echo "Installation completed, please give below commands after -> vagrant ssh master"
# sudo su - hduser
# hdfs namenode -format
# start-all.sh
echo "**********************************************************************************************"