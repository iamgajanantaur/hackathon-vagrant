#!/bin/bash

set -e  # Exit on error

echo "Updating package lists..."
sudo apt-get update -y

echo "Installing OpenJDK 8 and SSH..."
sudo apt-get install openjdk-8-jdk ssh -y

echo "Generating SSH key pair for vagrant user..."
sudo -u vagrant ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa -q

echo "Copying SSH key to localhost..."
sudo -u vagrant sshpass -p 'vagrant' ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub -o StrictHostKeyChecking=no vagrant@localhost

echo "Downloading Hadoop 3.3.2..."
cd /home/vagrant
sudo -u vagrant bash -c "wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz"

echo "Extracting Hadoop archive..."
sudo -u vagrant bash -c "tar xf hadoop-3.3.2.tar.gz"

echo "Setting up environment variables for vagrant user..."
cat <<EOF | sudo tee -a /home/vagrant/.bashrc
# Hadoop and Java environment variables
export PDSH_RCMD_TYPE=ssh
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/home/vagrant/hadoop-3.3.2
export PATH=\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin:$PATH
EOF

echo "Applying environment variables..."
sudo -u vagrant bash -c "source /home/vagrant/.bashrc && echo '✔ Environment variables set.'"

echo "Cloning configuration repository..."
sudo -u vagrant git clone https://github.com/iamgajanantaur/hackathon-vagrant.git

echo "Copying Hadoop configuration files..."
sudo -u vagrant cp /home/vagrant/hackathon-vagrant/vmware/singlenode/localhost/* /home/vagrant/hadoop-3.3.2/etc/hadoop/

IP=$(hostname -I | awk '{print $1}')

echo "✔ Installation complete!"
echo "Next steps:"
echo "---------------------------------------"
echo "1. SSH into the Vagrant machine:"
echo "   > vagrant ssh"
echo ""
echo "2. Format the Hadoop Namenode:"
echo "   > hdfs namenode -format"
echo ""
echo "3. Start Hadoop services:"
echo "   > start-all.sh"
echo ""
echo "---------------------------------------"
echo "Access Hadoop UI at: http://$IP:9870/"

