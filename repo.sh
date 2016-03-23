#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring and syncing a local repository on RHEL7/CentOS7.
#USAGE: Edit the variables with your configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

$repodir=""      # Example - /home/repos/centos/7/
$mirror=""        # Example - ftp.plusline.de/CentOS/7/
$reponame=""      # Example - Local CentOS 7 Repository
$filename=""      # Example - local.repo
$repolist=""

# Install packages
yum install createrepo rsync httpd -y

# Create directory where repository will be downloaded
mkdir -p $repodir

# Create repository
createrepo $repodir

# Create symbolic link between local repository and ftp directory
$reporoot=$(echo $repodir | cut -d/ -f2,3)
ln -s $reporoot /var/www/html

# Start apache service
systemctl start httpd

# Define repositories in /etc/yum.repos.d/ and create synced directories
for repo in $repolist; do
echo -e '['$repo']
name='$repo'
baseurl=ftp://'$HOSTNAME'/repos/centos/7/'$repo'/x86_64
gpgcheck=0' >> /etc/yum.repos.d/local.repo
rsync -rz --progress rsync://$mirror/$repo/x86_64 $localdir/$repo
done

exit 0
