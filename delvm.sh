#!/bin/bash

$vm=""
$pool=""

virsh list --all
read -p "Enter virtual machine name to delete: " vm
virsh destroy $vm
virsh undefine $vm
virsh pool-refresh $pool
virsh vol-delete --pool $pool $vm.img

exit 0
