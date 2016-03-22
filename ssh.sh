#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring the SSH service on RHEL7/CentOS7.
#USAGE: Edit the variables with your configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

# Declare Variables
permitroot=""       # Enable or Disable SSH root access - Options: yes, no
port=""             # Set port for SSH service
protocol=""         # Set SSH Protocol - Options: 1, 2
allowusers=""       # Optional - Leave blank if uneeded - Set allowed users - Usage: Enter space between users

# Create a backup of default sshd_config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_default

# Change root permission, protocol and port configuration in sshd_config based on set variables
sed -i 's/#PermitRootLogin yes/PermitRootLogin '$permitroot'/' /etc/ssh/sshd_config
sed -i 's/#Protocol 2/Protocol '$protocol'/' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port '$port'/' /etc/ssh/sshd_config

# Run and set allowed users if variable is not left blank
if [ -n "$allowusers" ]; then
  echo AllowUsers $allowusers >> /etc/ssh/sshd_config
fi

# Restart SSH service
systemctl restart sshd

exit 0
