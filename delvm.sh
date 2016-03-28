#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script that completely removes a selected virtual machine.
#USAGE: Edit the variables with desired VM settings define variables as agruments and execute on a KVM enabled RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

# Edit variables or define variables as agruments. Example - delv.sh vm pool
vm=$1      # Virtual machine name
pool=$2    # Pool name

###############################################################################################################################

virsh destroy "$vm"
virsh undefine "$vm"
virsh vol-delete --pool "$pool" "$vm".img

exit 0
