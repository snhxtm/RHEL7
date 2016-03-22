#!/bin/bash

$vm=""

virsh list --all
read -p "Enter virtual machine name to delete: " vm
virsh destroy $vm
virsh undefine $vm
virsh vol-delete --pool vg0 $vm.img
#rm -f /var/kvm/images/$vm

exit 0
