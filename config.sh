#!/bin/bash

###############################################################################################################################
#DESCRIPTION: Script that installs extra packages repository, runs a full update and installs essential packages.
#USAGE: Execute over a fresh minimal installation of RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

#add extra packages repository
yum install epel-release -y

#run full system update
yum update -y

#install essential tools
yum install net-tools bind-utils pciutils usbutils yum-utils wget zip unzip psmisc gdisk mlocate at ntp ntpdate -y

exit 0
