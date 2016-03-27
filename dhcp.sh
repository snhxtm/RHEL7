#!/bin/bash

#not finished

domain=""
dns=""
subnet=""
netmask=""
rangefr=""
rangeto=""
broadcast=""
ipaddr=""
interface=""

yum install dhcp -y

echo -e 'option domain-name "lab.lan";
option domain-name-servers 192.168.2.2;
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 192.168.2.0 netmask 255.255.255.0 {
  #interface en16777736
  #filename pxelinux.0
  range dynamic-bootp 192.168.2.200 192.168.2.254;
  option broadcast-address 192.168.2.255;
  option routers 192.168.2.1;
}' > /etc/dhcp/dhcpd.conf 


exit 0
