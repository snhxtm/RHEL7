#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for creating a new virtual machine on a KVM enabled RHEL7/CentOS7 installation.
#USAGE: Edit the variables with desired VM settings and execute on a KVM enabled RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

ostype=""
osvariant==""
name=""
vcpu=""
ram=""
disksize=""
diskpath==""
graphics==""
nbridge=""
console=""
location=""
args=""

virsh --os-type $ostype --os-variant $osvariant --name $name --vcpus $vcpu --ram $ram --disk path=$diskpath,size=$disksize --graphics $graphics --network bridge=$nbridge --console $console --location ''$location'' --extra-args ''$args''

exit 0
