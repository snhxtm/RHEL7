#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring and syncing a dhcp server on RHEL7/CentOS7.
#USAGE: Edit the variables with desired configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

domain=""           # Set domain name
dns1=""             # Set nameserver
dns2=""             # Optional - Leave blank if not needed - Set 2nd nameserver
dns3=""             # Optional - Leave blank if not needed - Set 3rd nameserver
subnet=""           # Set subnet
netmask=""          # Set netmask
rangefr=""          # Set dhcp range from
rangeto=""          # Set dhcp range to
broadcast=""        # Set broadcast address
ipaddr=""           # Set ip address
deflease=""         # Set default lease time
maxlease=""         # Set maximum lease time

###############################################################################################################################

# Install dhcp service
yum install dhcp -y

# Configure dhcp service settings
echo -n "option domain-name-servers $dns1" > /etc/dhcp/dhcpd.conf 
if [ -n "$dns2" ]; then
  echo -n ", $dns2" >> /etc/dhcp/dhcpd.conf 
  if [ -n "$dns3" ]; then
    echo -n ", $dns3" >> /etc/dhcp/dhcpd.conf 
  fi
fi

echo -e ";\noption domain-name \"$domain\";
default-lease-time $deflease;
max-lease-time $maxlease;
authoritative;

subnet $subnet netmask $netmask {
  filename \"/pxelinux.0\";
  range dynamic-bootp $rangefr $rangeto;
  option broadcast-address $broadcast;
  option routers $ipaddr;
}" >> /etc/dhcp/dhcpd.conf 

exit 0
