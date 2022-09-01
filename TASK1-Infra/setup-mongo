#!/bin/bash
sudo mdadm --verbose --create /dev/md0 --level=10 --chunk=256 --raid-devices=4 /dev/sdh1 /dev/sdh2 /dev/sdh3 /dev/sdh4
echo 'DEVICE /dev/sdh1 /dev/sdh2 /dev/sdh3 /dev/sdh4' | sudo tee -a /etc/mdadm.conf
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm.conf
sudo blockdev --setra 128 /dev/md0
sudo blockdev --setra 128 /dev/sdh1
sudo blockdev --setra 128 /dev/sdh2
sudo blockdev --setra 128 /dev/sdh3
sudo blockdev --setra 128 /dev/sdh4
sudo dd if=/dev/zero of=/dev/md0 bs=512 count=1
sudo pvcreate /dev/md0
sudo vgcreate vg0 /dev/md0
sudo lvcreate -l 90%vg -n data vg0
sudo lvcreate -l 5%vg -n log vg0
sudo lvcreate -l 5%vg -n journal vg0
sudo mke2fs -t ext4 -F /dev/vg0/data
sudo mke2fs -t ext4 -F /dev/vg0/log
sudo mke2fs -t ext4 -F /dev/vg0/journal

sudo mkdir /data
sudo mkdir /log
sudo mkdir /journal

sudo echo '/dev/vg0/data /data ext4 defaults,auto,noatime,noexec 0 0' | sudo tee -a /etc/fstab
sudo echo '/dev/vg0/log /log ext4 defaults,auto,noatime,noexec 0 0' | sudo tee -a /etc/fstab
sudo echo '/dev/vg0/journal /journal ext4 defaults,auto,noatime,noexec 0 0' | sudo tee -a /etc/fstab

sudo mount /data
sudo mount /log
sudo mount /journal

sudo ln -s /journal /data/journal

sudo yum install -y python2 cyrus-sasl-gssapi

cd /tmp
wget https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/4.4/x86_64/RPMS/mongodb-org-server-4.4.8-1.amzn1.x86_64.rpm
wget https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/4.4/x86_64/RPMS/mongodb-org-tools-4.4.8-1.amzn1.x86_64.rpm
wget https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/4.4/x86_64/RPMS/mongodb-org-mongos-4.4.8-1.amzn1.x86_64.rpm
wget https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/4.4/x86_64/RPMS/mongodb-org-4.4.8-1.amzn1.x86_64.rpm
wget https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/4.4/x86_64/RPMS/mongodb-database-tools-100.4.1.x86_64.rpm
wget https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/4.4/x86_64/RPMS/mongodb-org-database-tools-extra-4.4.8-1.amzn1.x86_64.rpm
wget https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/4.4/x86_64/RPMS/mongodb-org-shell-4.4.8-1.amzn1.x86_64.rpm

sudo rpm -ivh mongodb-org-server-4.4.8-1.amzn1.x86_64.rpm 
sudo rpm -ivh mongodb-org-tools-4.4.8-1.amzn1.x86_64.rpm 
sudo rpm -ivh mongodb-org-mongos-4.4.8-1.amzn1.x86_64.rpm 
sudo rpm -ivh mongodb-org-4.4.8-1.amzn1.x86_64.rpm 
sudo rpm -ivh mongodb-database-tools-100.4.1.x86_64.rpm 
sudo rpm -ivh mongodb-org-database-tools-extra-4.4.8-1.amzn1.x86_64.rpm 
sudo rpm -ivh mongodb-org-shell-4.4.8-1.amzn1.x86_64.rpm


sudo sed -i 's#/var/lib/mongo#/data#g' /etc/mongod.conf
sudo sed -i 's#127.0.0.1#0.0.0.0#g' /etc/mongod.conf
sudo sed -i 's#/var/log/mongodb/mongod.log#/log/mongod.log#g' /etc/mongod.conf
sudo mkdir -p /data/db
sudo mkdir -p /var/run/mongodb
sudo chown -R mongod:mongod /data
sudo chown -R mongod:mongod /log
sudo chown -R mongod:mongod /var/run/mongodb
sudo rm -rf /data/*
sudo rm -rf /var/run/mongodb/mongod.pid
sudo chkconfig mongod on
sudo /etc/init.d/mongod start

