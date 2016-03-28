#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring network booting from local repository on RHEL7/CentOS7.
#USAGE: Edit the variables with your configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

repodir=""    # Example - /var/www/html/centos/7/os/x_86_64

###############################################################################################################################

# Install Packages
yum install xinetd syslinux tftp-server -y

# Enable tftp
sed -i 's/^disable.yes$/^disable.no$/' /etc/xinetd.d/tftp

# Copy syslinux files
cp /usr/share/syslinux/{pxelinux.0,menu.c32,memdisk,mboot.c32,chain.c32} /var/lib/tftpboot/

# Copy vmlinuz and initrd.img files
cp $repodir/images/pxeboot/{vmlinuz,initrd.img} /var/lib/tftpboot

# Create config directory for pxe menu configuration
mkdir -p /var/lib/tftpboot/pxelinux.cfg

# Create and configure pxe menu configuration file
echo "default menu.c32
prompt 0
timeout 300
ONTIMEOUT local

menu title PXE MENU
 
label 1
menu label ^1) Install CentOS 7
kernel vmlinuz
append initrd.img method=http://$HOSTNAME/centos/7/os/x86_64 devfs=nomount" > /var/lib/tftpboot/pexlinux.cfg/default

# Start and enable Xinetd
systemctl start xinetd
systemctl enable xinetd

exit 0
