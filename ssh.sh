#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring the SSH service on RHEL7/CentOS7.
#USAGE: Edit the variables with your configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

# Declate Variables
permitroot=""       # Enable or Disable SSH root access - Options: yes, no
port=""             # Set port for SSH service
protocol=""         # Set SSH Protocol - Options: 1, 2
allowusers=""       # Optional - Leave blank if uneeded - Set allowed users - Usage: Enter space between users

# Creates a temporary backup of sshd_config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bkp

# Changes root permission, protocol and port configuration in sshd_config based on set variables
cat /etc/ssh/sshd_config_bkp | sed 's/#PermitRootLogin yes/PermitRootLogin '$permitroot'/'  | sed 's/#Protocol 2/Protocol '$protocol'/' | sed 's/#Port 22/Port '$port'/' > /etc/ssh/sshd_config

# Runs and sets allowed users if variable is not left blank
if [ -n "$allowusers" ]; then
  echo AllowUsers $allowusers >> /etc/ssh/sshd_config
fi

# Removes ssh_config backup file
rm -f /etc/ssh/sshd_config_bkp

# Restarts SSH service
systemctl restart sshd

exit 0
