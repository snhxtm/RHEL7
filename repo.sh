#!/bin/bash

yum install createrepo vsftpd -y

mkdir -p /home/repos/centos/7/packages

createrepo /home/repos/centos/7/packages

rsync -rz --progress rsync://ct.mirror.garr.it/mirrors/CentOS/7/os/x86_64/ /home/repos/CentOS/7/

ln -s /var/ftp/public/centos /home/repos/centos

echo -e '[mylocalrepo] \
name=Local CentOS 7 Repository \
baseurl=ftp://vm001.local/centos/7 \
gpgcheck=0' > /etc/yum.repos.d/local.repo

exit 0
