#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for creating a new virtual machine with virt-install on a KVM enabled RHEL7/CentOS7.
#USAGE: Edit the variables with desired VM settings and execute on a KVM enabled RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

ostype=""         # Example - linux
osvariant=""      # Example - rhel7
name=""           # Example - vm001
vcpu=""           # Example - 1
ram=""            # Example - 1024
disksize=""       # Example - 10
diskpath=""       # Example - /var/kvm/images
graphics=""       # Example - none
nbridge=""        # Example - br0
location=""       # Example - http://mirror.centos.org/centos/7/os/x86_64/
args=""           # Example - console=tty0 console=ttyS0,115200
ks=""             # Example - https://raw.githubusercontent.com/Halakor/RHEL7/dev/vm.ks

###############################################################################################################################

virt-install \
--os-type $ostype \
--os-variant $osvariant \
--name $name \
--vcpus $vcpu \
--ram $ram \
--disk path=$diskpath/$name.img,size=$disksize \
--graphics $graphics \
--network bridge=$nbridge \
--location $location \
--extra-args="ks=$ks $args"

exit 0
