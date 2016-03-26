#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring and syncing a local repository on RHEL7/CentOS7.
#USAGE: Edit the variables with your configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

$repodir=""       # Example - /var/www/html/centos/7/
$mirror=""        # Example - ftp.plusline.de/CentOS/7/
$filename=""      # Example - local.repo
$repolist=""      # Example - os updates extras
$epel=""          # Example - ftp.plusline.de/epel/7/
$epelenable=""    # Example - y/n

###############################################################################################################################

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

# Define repositories in /etc/yum.repos.d/ and create synced directories
for repo in $repolist; do
echo -e '['$repo']
name='$repo'
baseurl=ftp://'$HOSTNAME'/centos/7/'$repo'/x86_64
gpgcheck=0' >> /etc/yum.repos.d/local.repo
rsync -av rsync://$mirror/$repo/x86_64 $repodir/$repo
cron=$cron; rsync -av rsync://$mirror/$repo/x86_64 $repodir/$repo
done

# Define epel repository in /etc/yum.repos.d/ and create synced directories if variable is set
if [ -n "$epel" ]; then
echo -e '[epel]
name=epel
baseurl=ftp://'$HOSTNAME'/centos/7/epel/x86_64
gpgcheck=0' >> /etc/yum.repos.d/local.repo
if [ $epelenable == "y" ]; then
echo "enabled=1" >> /etc/yum.repos.d/local.repo
else
echo "enabled=0" >> /etc/yum.repos.d/local.repo
fi
rsync -av --exclude debug/ rsync://$epel/x86_64 $repodir/epel
cron=$cron; rsync -av --exclude debug/ rsync://$epel/x86_64 $repodir/epel
fi

# Add cronjob to keep repos synced
echo 0 0 * * * 0 root $cron >> /etc/crontab

# Configure selinux
semanage fcontext --add -t httpd_sys_rw_content_t 'var/www/html(/.*)?'
restorecon -R -v /var/www/html

# Remove apache test page
rm -f /etc/httpd/conf.d/welcome.conf

# Start and enable apache service
systemctl start httpd
systemctl enable httpd

exit 0
