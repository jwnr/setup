#!/bin/sh

# need to open port 51820

dnf install -y wireguard-tools
cp ./jkbrn.conf /etc/wireguard/
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
reboot
