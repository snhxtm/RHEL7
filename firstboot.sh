#!/bin/bash

#add extra packages repository
yum install epel-release -y

#run full system update
yum update -y

#install essential tools
yum install net-tools bridge-utils -y

exit 0