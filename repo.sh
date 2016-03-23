#!/bin/bash

$reposdir=""       # Example - /home/repos/centos/7/
$mirror=""        # Example - rsync://ftp.plusline.de/CentOS/7/os_x64_86
$reponame=""      # Example - Local CentOS 7 Repository
$filename=""      # Example - local.repo

yum install createrepo rsync vsftpd -y

mkdir -p $reposdir

createrepo $reposdir

rsync -rz --progress rsync://$mirror $localdir
# ln -s /home/repos /var/ftp/
$reposroot=$(echo $reposdir | cut -d/ -f2,3)
ln -s $reposroot /var/ftp
#test=$(echo $test | cut -d/ -f2,3)

echo -e '[mylocalrepo] \
name='$name' \
baseurl=ftp://'$HOSTNAME'/centos/7 \
gpgcheck=0' > /etc/yum.repos.d/$filename

exit 0
