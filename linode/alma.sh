setenforce 0;sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
systemctl disable nftables;systemctl disable firewalld;systemctl restart dbus






dnf -y upgrade

timedatectl set-timezone Asia/Tokyo;localectl set-locale LANG=ja_JP.UTF-8



sed -i -e '/^#Port *.*/d' /etc/ssh/sshd_config
sed -i -e '/^Port *.*/d' /etc/ssh/sshd_config
sed -i -e '/^#Protocol *.*/d' /etc/ssh/sshd_config
sed -i -e '/^Protocol *.*/d' /etc/ssh/sshd_config
sed -i -e '/PermitRootLogin/d' /etc/ssh/sshd_config
sed -i -e '/PubkeyAuthentication/d' /etc/ssh/sshd_config
sed -i -e '/PermitEmptyPasswords/d' /etc/ssh/sshd_config
sed -i -e '/PasswordAuthentication/d' /etc/ssh/sshd_config
sed -i -e '/AuthorizedKeysFile/d' /etc/ssh/sshd_config
echo -e \\nPort 57031\\nProtocol 2\\nPermitRootLogin without-password\\nPubkeyAuthentication yes\\nPermitEmptyPasswords no\\nPasswordAuthentication no\\nAuthorizedKeysFile .ssh/authorized_keys >> /etc/ssh/sshd_config
firewall-cmd --add-port=57031/tcp --permanent
