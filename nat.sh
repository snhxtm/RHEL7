#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring a NAT Gateway with firewalld.
#USAGE: Edit the variables with your configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

intif=""          # Set Internal interface
extif=""          # Set External interface
services=""       # Optional - leave blank if uneeded. Add services as list - Example - "http ssh dns"

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

# Reload firewalld
firewall-cmd --complete-reload

if [ -n "$services" ]; then
for service in $services; do
firewall-cmd --zone=internal --add-service=$service --permanent
done
fi
exit 0
