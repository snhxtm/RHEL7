#!/bin/bash

###############################################################################################################################
#DESCRIPTION: An automated bash script for configuring a dns server on RHEL7/CentOS7.
#USAGE: Edit the variables with desired configuration and execute on RHEL7/CentOS7.
#CREATED BY: William Thomas Bland.
###############################################################################################################################

ipaddr=""           # Set ip address of dns server

###############################################################################################################################

# Install bind packages
yum install bind bind-utils -y

# Change ip address of dns server
sed i "s/listen-on port 53 { *; };/listen-on port 53 { $ipaddr; };/" /etc/named.conf

# Allow querying
sed i "s/allow-query     { localhost; };/allow-query     { any; };/" /etc/named.conf

# Edit zones
sed -i "s/localhost\.localdomain/lab\.lan/"  /etc/named.rfc1912.zones
sed -i "s/none/any/"  /etc/named.rfc1912.zones

for i in 4 3 2 1; do
ip=$(hostname -i cut -d. -f$i)
iprev=$("$iprev.$ip")
done

sed -i "s/1.0.0.127/$iprev/" /etc/named.rfc1912.zones
sed -i "s/reverse-zone/named-loopback/" /etc/named.rfc1912.zones

# Create and configure forward zone
echo "$TTL 3H
@       IN SOA   @  $HOSTNAME. (
                                1     ; serial
                                1D    ; refresh
                                1H    ; retry
                                1W    ; expire
                                3H )  ; minimum
        IN       NS     $HOSTNAME.
host01  IN       A      $ipaddr" > /var/named/forward.zone

# Create and configure reverse zone
echo "$TTL 3H
@       IN SOA   @  $HOSTNAME. (
                                1     ; serial
                                1D    ; refresh
                                1H    ; retry
                                1W    ; expire
                                3H )  ; minimum
        IN       NS     $HOSTNAME.
$(hostname -i | cut -d. -f4)     IN       PTR    $HOSTNAME." > /var/named/reverse.zone

# Start and enable named service
systemctl start named
systemctl enable named

exit 0
