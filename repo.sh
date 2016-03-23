#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring and syncing a local repository on RHEL7/CentOS7.
#USAGE: Edit the variables with your configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

$reposdir=""      # Example - /home/repos/centos/7/
$mirror=""        # Example - rsync://ftp.plusline.de/CentOS/7/os_x64_86
$reponame=""      # Example - Local CentOS 7 Repository
$filename=""      # Example - local.repo

# Install packages
yum install createrepo rsync vsftpd -y

# Create directory where repository will be downloaded
mkdir -p $reposdir

# Create repository
createrepo $reposdir

# Sync local repository with mirror
rsync -rz --progress rsync://$mirror $localdir

# Create symbolic link between local repository and ftp directory
$reposroot=$(echo $reposdir | cut -d/ -f2,3)
ln -s $reposroot /var/ftp

# Start ftp service
systemctl start vsftpd

# Define repository in /etc/yum.repos.d/
echo -e '[localrepo] \
name='$name' \
baseurl=ftp://'$HOSTNAME'/repos/centos/7 \
gpgcheck=0' > /etc/yum.repos.d/$filename

exit 0
