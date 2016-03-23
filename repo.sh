#!/bin/bash

$repodir=""       # Example - /home/repos/centos/7/
$mirror=""        # Example - rsync://ftp.plusline.de/CentOS/7/os_x64_86
$ftpdir=""        # Example - /var/ftp/public/centos
$reponame=""      # Example - Local CentOS 7 Repository
$filename=""      # Example - local.repo

yum install createrepo rsync vsftpd -y

mkdir -p $repodir

createrepo $repodir

rsync -rz --progress rsync://$mirror $localdir

ln -s $ftpdir $localdir

echo -e '[mylocalrepo] \
name='$name' \
baseurl=ftp://'$HOSTNAME'/centos/7 \
gpgcheck=0' > /etc/yum.repos.d/$filename

exit 0
