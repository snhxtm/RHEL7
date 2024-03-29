###############################################################################################################################
#DESCRIPTION: A kickstart file for an unattended installation of RHEL7/CentOS7.
#USAGE: Edit settings to change installation instructions. Root password set to "temp".
#CREATED BY: William Thomas Bland.
###############################################################################################################################

#version=DEVEL

# System authorization information
auth --enableshadow --passalgo=sha512

# Use network installation
url --url="http://mirror.centos.org/centos/7/os/x86_64/"

# Use text mode install
text
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=vda

# Keyboard layouts
keyboard --vckeymap=gb --xlayouts='gb'

# System language
lang en_GB.UTF-8

# Network information
network  --bootproto=dhcp --device=eth0 --onboot=on --noipv6 --activate
network  --hostname=localhost.localdomain

# Temporary root password
rootpw "temp"

# Do not configure the X Window System
skipx

# System timezone
timezone Europe/Malta --isUtc

# System bootloader configuration
bootloader --location=mbr --boot-drive=vda
autopart --type=lvm

# Partition clearing information
clearpart --all --initlabel --drives=vda

# Install Packages
%packages
@core

%end

# Disable kdump
%addon com_redhat_kdump --disable --reserve-mb='auto'

%end

# Post installation
%post 

%end
