#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring and syncing a local repository on RHEL7/CentOS7.
#USAGE: Edit the variables with your configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

$repodir=""       # Example - /home/repos/centos/7/
$mirror=""        # Example - ftp.plusline.de/CentOS/7/
$filename=""      # Example - local.repo
$repolist=""      # Example - os updates extras
$epel=""          # Example - ftp.plusline.de/epel/7/
$epelenable=""    # Example - y/n

# Install packages
yum install policycoreutils-python createrepo rsync httpd -y

# Create directory where repository will be downloaded
mkdir -p $repodir

# Create repositories
for repo in $repolist; do
createrepo $repodir/$repo/x86_64
done

# Create epel repo if variable is set
if [ -n "$epel" ]; then
createrepo $repodir/epel/x86_64
fi

# Create symbolic link between local repository and ftp directory
$reporoot=$(echo $repodir | cut -d/ -f2,3)
ln -s $reporoot /var/www/html

# Configure selinux
semanage fcontext --add -t httpd_sys_rw_content_t 'var/www/html/repos(/.*)?'
restorecon -R -v /var/www/html/repos

# Remove apache test page
rm -f /etc/httpd/conf.d/welcome.conf

# Start and enable apache service
systemctl start httpd
systemctl enable httpd

# Define repositories in /etc/yum.repos.d/ and create synced directories
for repo in $repolist; do
echo -e '['$repo']
name='$repo'
baseurl=ftp://'$HOSTNAME'/repos/centos/7/'$repo'/x86_64
gpgcheck=0' >> /etc/yum.repos.d/local.repo
rsync -rz --progress rsync://$mirror/$repo/x86_64 $localdir/$repo
done

# Define epel repository in /etc/yum.repos.d/ and create synced directories if variable is set
if [ -n "$epel" ]; then
echo -e '[epel]
name=epel
baseurl=ftp://'$HOSTNAME'/repos/centos/7/epel/x86_64
gpgcheck=0' >> /etc/yum.repos.d/local.repo
if [ $epelenable == "y" ]; then
echo "enabled=1" >> /etc/yum.repos.d/local.repo
else
echo "enabled=0" >> /etc/yum.repos.d/local.repo
fi
rsync -rz --progress --exclude debug/ rsync://$epel/x86_64 $localdir/epel
fi

exit 0
