#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script that completely removes a selected virtual machine.
#USAGE: Edit the variables with desired VM settings and execute on a KVM enabled RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

$vm=""      # Virtual machine name
$pool=""    # KVM images folder

virsh destroy $vm
virsh undefine $vm
virsh pool-refresh $pool
virsh vol-delete --pool $pool $vm.img

exit 0
