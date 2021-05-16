#!/bin/bash

#=== system
#==================================
setenforce 0;sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
systemctl disable auditd
systemctl disable import-state
systemctl disable kdump
systemctl disable selinux-autorelabel-mark
dnf -y upgrade
dnf install -y bash-completion
timedatectl set-timezone Asia/Tokyo;localectl set-locale LANG=ja_JP.UTF-8


#=== SSH
#==================================
sed -i -e '/^#Port *.*/d' /etc/ssh/sshd_config
sed -i -e '/^Port *.*/d' /etc/ssh/sshd_config
sed -i -e '/^#Protocol *.*/d' /etc/ssh/sshd_config
sed -i -e '/^Protocol *.*/d' /etc/ssh/sshd_config
sed -i -e '/PermitRootLogin/d' /etc/ssh/sshd_config
sed -i -e '/PubkeyAuthentication/d' /etc/ssh/sshd_config
sed -i -e '/PermitEmptyPasswords/d' /etc/ssh/sshd_config
sed -i -e '/PasswordAuthentication/d' /etc/ssh/sshd_config
sed -i -e '/AuthorizedKeysFile/d' /etc/ssh/sshd_config
echo -e \\nPort $1\\nProtocol 2\\nPermitRootLogin without-password\\nPubkeyAuthentication yes\\nPermitEmptyPasswords no\\nPasswordAuthentication no\\nAuthorizedKeysFile .ssh/authorized_keys >> /etc/ssh/sshd_config
firewall-cmd --add-port=$1/tcp --permanent
mkdir /root/.ssh;chmod 700 ~/.ssh

echo '===== command succeeded ====='
