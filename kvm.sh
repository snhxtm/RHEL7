#!/bin/bash

###############################################################################################################################
#DESCRIPTION: Automated bash script for configuring a kvm hypervisor on a minimal RHEL7/CentOS7 installation.
#USAGE: Edit the variables with your network configuration and execute over a fresh minimal installation of RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

# Declare variables
ipaddr=""       # Set IP Address for this machine
netmask=""      # Set Netmask for this machine
gateway=""      # Set Network Gateway
dns1=""         # Set DNS Server
dns2=""         # Optional - Set 2nd DNS Server - leave blank if not needed
dns3=""         # Optional - Set 3nd DNS Server - leave blank if not needed
hostname=""     # Set Hostname for this machine

# Install network and kvm tools
yum install bridge-utils qemu-kvm libvirt virt-install -y

# Enable and start libvirt service
systemctl enable libvirtd
systemctl start libvirtd

# Stop network manager
systemctl stop NetworkManager

# Stop network service
systemctl stop network

# Create bridged adapter
echo -e 'DEVICE="br0"
TYPE="Bridge"
IPADDR="'$ipaddr'"
NETMASK="'$netmask'"
BOOTPROTO="none"
ONBOOT="yes"
NM_CONTROLLED="no"' > /etc/sysconfig/network-scripts/ifcfg-br0

# Find ethernet device name
eth=`ls /etc/sysconfig/network-scripts | grep ifcfg-e | cut -d- -f2`

# Modify ethernet adapter
echo -e 'DEVICE="'$eth'"
TYPE="Ethernet"
BOOTPROTO="none"
ONBOOT="yes"
NM_CONTROLLED="no"
BRIDGE="br0"' > /etc/sysconfig/network-scripts/ifcfg-$eth

#set gateway
echo 'GATEWAY="'$gateway'"' > /etc/sysconfig/network

#set nameserver
echo $hostname | cut -d. -f2,3 | sed s/^/"search "/ > /etc/resolv.conf
echo nameserver $dns1 >> /etc/resolv.conf

# Add 2nd and/or 3rd nameservers if variables are set
if [ -n "$dns2" ]; then
  echo nameserver $dns2 >> /etc/resolv.conf
  if [ -n "$dns3" ]; then
    echo nameserver $dns3 >> /etc/resolv.conf
  fi
fi

# Set hostname
hostnamectl set-hostname $hostname

# Start network service
systemctl start network

# Create KVM images folder
mkdir -p /var/kvm/images

exit 0
