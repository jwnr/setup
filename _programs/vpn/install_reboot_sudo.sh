#!/bin/sh

dnf install -y wireguard-tools
cp ./jkbrn.conf /etc/wireguard/
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
reboot
