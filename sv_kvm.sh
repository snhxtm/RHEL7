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

###############################################################################################################################

# Install network and kvm tools
yum install bridge-utils qemu-kvm libvirt virt-install -y

# Enable and start libvirt service
systemctl enable libvirtd
systemctl start libvirtd

# Stop and disable network manager
systemctl stop NetworkManager
systemctl disable NetworkManager

# Stop network service
systemctl stop network

# Create bridged adapter
echo "DEVICE=\"br0\"
TYPE=\"Bridge\"
BOOTPROTO=\"none\"
ONBOOT=\"yes\"
NM_CONTROLLED=\"no\"
IPADDR=\"$ipaddr\"
NETMASK=\"$netmask\"" > /etc/sysconfig/network-scripts/ifcfg-br0

# Find ethernet device name
eth=$(echo /etc/sysconfig/network-scripts/ifcfg-e* | cut -d- -f3)

# Modify ethernet adapter
echo "DEVICE=\"$eth\"
TYPE=\"Ethernet\"
BOOTPROTO=\"none\"
ONBOOT=\"yes\"
NM_CONTROLLED=\"no\"
BRIDGE=\"br0\"" > /etc/sysconfig/network-scripts/ifcfg-"$eth"

# Set gateway
echo GATEWAY=\"$gateway\" > /etc/sysconfig/network

# Set nameserver
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
