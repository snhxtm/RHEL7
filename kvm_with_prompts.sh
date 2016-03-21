#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An interactive bash script for configuring a kvm hypervisor on a minimal RHEL7/CentOS7 installation.
#USAGE: Execute over a fresh minimal installation of RHEL7/CentOS7 and follow the prompts.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

#declare variables
eth=""
ipaddr=""
netmask=""
gateway=""
dns1=""
dns2=""
dns3=""
yn=""
hostname=""

#prompts to set values of declared variables
read -p "Enter ip address: " ipaddr 
read -p "Enter netmask: " netmask
read -p "Enter gateway: " gateway
read -p "Enter dns server: " dns1
read -p "Do you want to add a second dns server? (y/n): " yn #prompts choice to add a 2nd nameserver in /etc/resolv.conf

if [  $yn == "y" ]; then
  read -p "Enter dns server: " dns2
  read -p "Do you want to add a third dns server? (y/n): " yn #prompts choice to add a 3rd nameserver in /etc/resolv.conf
  if [  $yn == "y" ]; then
    read -p "Enter dns server: " dns3
  fi
fi

read -p "Enter hostname: " hostname

#add extra packages repository
yum install epel-release -y

#run full system update
yum update -y

#install network and kvm tools
yum install net-tools bridge-utils qemu-kvm libvirt virt-install -y

#enable and start libvirt service
systemctl enable libvirtd
systemctl start libvirtd

#stop the network manager
systemctl stop NetworkManager

#stop the network service
systemctl stop network

#enable nested vms and ignore msrs errors
echo 'options kvm_intel nested=1
options kvm ignore_msrs=1' > /etc/modprobe.d/kvm.conf

#create bridged adapter
echo -e 'DEVICE="br0"
TYPE="Bridge"
IPADDR="'$ipaddr'"
NETMASK="'$netmask'"
BOOTPROTO="none"
ONBOOT="yes"
NM_CONTROLLED="no"' > /etc/sysconfig/network-scripts/ifcfg-br0

#find ethernet device name
eth=`ls /etc/sysconfig/network-scripts | grep ifcfg-e | cut -d- -f2`

#modify ethernet adapter
echo -e 'DEVICE="'$eth'"
TYPE="Ethernet"
BOOTPROTO="none"
ONBOOT="yes"
NM_CONTROLLED="no"
BRIDGE="br0"' > /etc/sysconfig/network-scripts/ifcfg-$eth

#set gateway
echo 'GATEWAY="'$gateway'"' > /etc/sysconfig/network

#set dns server
echo $hostname | cut -d. -f2,3 | sed s/^/"search "/ > /etc/resolv.conf
echo nameserver $dns1 >> /etc/resolv.conf

#adds 2nd and/of 3rd nameservers if variables are set
if [ -n "$dns2" ]; then
  echo nameserver $dns2 >> /etc/resolv.conf
  if [ -n "$dns3" ]; then
    echo nameserver $dns3 >> /etc/resolv.conf
  fi
fi

#set hostname
hostnamectl set-hostname $hostname

#start network service
systemctl start network

exit 0