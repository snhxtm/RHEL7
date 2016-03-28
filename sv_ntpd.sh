#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring ntp on RHEL7/CentOS7.
#USAGE: Edit the variables with desired configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

ntplist=""  # Set one of more servers with a space separater - Example: "0.it.pool.ntp.org 1.it.pool.ntp.org 2.it.pool.ntp.org"

###############################################################################################################################

# Install ntp service
yum install ntp -y

# Removes default ntp servers
sed -i '/# These servers were defined in the installation:/,/# For more information about this file{//!d}' /etc/ntp.conf

for ntp in $ntplist; do
sed -i "/# These servers were defined in the installation:/i server $ntp iburst" /etc/ntp.conf
done

# Start and enable ntp service
systemctl start ntpd
systemctl enable ntpd

exit 0
