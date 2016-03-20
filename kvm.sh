#!/bin/bash

#set variables
eth=""
ipaddr=""
netmask=""
gateway=""
dns1=""
#dns2=""
#dns3=""

#add extra packages repository
yum install epel-release -y

#run full system update
yum update -y

#install network and kvm tools
yum install net-tools bridge-utils qemu-kvm libvirt virt-install -y

#disable the network manager
service NetworkManager stop
service NetworkManager off

#restart network service
service network restart

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
echo -e 'search local
nameserver '$dns1'' > /etc/resolv.conf
#echo nameserver $dns2 >> /etc/resolv.conf
#echo nameserver $dns3 >> /etc/resolv.conf

#restart network service
service network restart

exit 0
