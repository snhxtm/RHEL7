#!/bin/bash

yum install xinetd syslinux tftp-server -y

sed -i 's/^disable.no$/^disable.yes$/' /etc/xinetd.d/tftp

cd /usr/share/syslinux

cp pxelinux.0 menu.c32 memdisk mboot.c32 chain.c32 /var/lib/tftpboot/

exit 0
