#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring a NAT Gateway with firewalld.
#USAGE: Edit the variables with your configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

intif=""          # Set Internal interface
extif=""          # Set External interface
services=""       # Optional - leave blank if uneeded. Add services as list - Example "http ssh dns"
tcp=""            # Optional - leave blank if uneeded. Add tcp port as list
udp=""            # Optional - leave blank if uneeded. Add services as list

###############################################################################################################################

# Install firewalld
yum install firewalld -y

# Enable IP forwarding
echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
sysctl -p

# Set Internal interface
firewall-cmd --change-interface=$intif --zone=internal --permanent

# Set External interface
firewall-cmd --change-interface=$extif --zone=external --permanent

# Set default interface to internal
firewall-cmd --set-default-zone=internal --permanent

# Add service
if [ -n "$services" ]; then
for servicelist in $services; do
firewall-cmd --zone=internal --add-service=$servicelist --permanent
done
fi

# Add tcp port
if [ -n "$tcp" ]; then
for tcplist in $tcp; do
firewall-cmd --zone=internal --add-service=$tcplist --permanent
done
fi

# Add udp port
if [ -n "$udp" ]; then
for udplist in $udp; do
firewall-cmd --zone=internal --add-service=$udplist --permanent
done
fi

# Reload firewalld
firewall-cmd --complete-reload

exit 0
