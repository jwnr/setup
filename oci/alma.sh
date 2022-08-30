setenforce 0;sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

systemctl disable selinux-autorelabel-mark nis-domainname sssd kdump nftables
systemctl disable firewalld;systemctl restart dbus
#### daemon (active)
# nis-domainname
#### daemon (inactive)
# selinux-autorelabel-mark, sssd, kdump, nftables

dnf -y upgrade
dnf -y install podman git

timedatectl set-timezone Asia/Tokyo
localectl set-locale LANG=ja_JP.UTF-8

#mkdir -p .config/containers
#echo -e "unqualified-search-registries = [\"docker.io\"]" > .config/containers/registries.conf

#### ssh
\cp -f /home/opc/.ssh/authorized_keys /root/.ssh
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
echo -e "+-------------------------------+\n|     \e[34mOracle Cloud\e[m instance     |\n+-------------------------------+" >/etc/motd

echo -e "\n==== succeeded ============================================="
echo -e " + disable SELinux\n + disable nftables,firewalld"
echo -e " + change locale & timezone (ja_JP.UTF-8 & Asia/Tokyo)"
echo -e " + install packages\n  - podman, git"
echo -e "============================================================\n"