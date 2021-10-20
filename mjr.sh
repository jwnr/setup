#!/bin/bash

echo -e "\n============================================================\n==== starting ==============================================\n============================================================"

# ==== mirror config
# ==================================
pacman-mirrors -c Japan,Taiwan,Singapore && pacman --noconfirm -Syyu

# ==== locale, time
# ==================================
sed -i -e 's/^.*ja_JP.UTF-8.*$/ja_JP.UTF-8 UTF-8/' /etc/locale.gen; locale-gen
sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf; source /etc/locale.conf
timedatectl set-ntp true
#systemctl enable systemd-timesyncd
#ntpdate ntp.nict.jp

# ==== fonts
# ==================================
pacman --noconfirm -S otf-ipaexfont
ln -snf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/

# ==== display
# ==================================
cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak
mkdir /etc/lightdm/sl; chmod 777 /etc/lightdm/sl
touch /etc/lightdm/sl/default.sh; ln -snf /etc/lightdm/sl/default.sh ./sl.sh
sed -i -e 's/^#display-setup-script=.*$/display-setup-script=\/etc\/lightdm\/sl\/sl.sh/' /etc/lightdm/lightdm.conf

# ==== packs
# ==================================
pacman -S --needed --noconfirm git rxvt-unicode vivaldi vivaldi-ffmpeg-codecs dolphin rofi fcitx fcitx-configtool fcitx-mozc fcitx-qt5 fcitx-gtk3; chmod -R 777 /usr/share/fcitx/skin/default /usr/share/fcitx/mozc/icon
pamac build --no-confirm google-chrome google-chrome-beta visual-studio-code-bin
pacman -Scc; pamac clean

echo -e "\n==== succeeded ============================================="
echo -e " + optimize mirror priority\n + sync package databases & upgrade local packages"
echo -e " + change locale (ja_JP.UTF-8)"
echo -e " + prepare font (install IPAex, disable bitmap font)"
echo -e " + install packages (by pacman)\n  - git, rxvt, Vivaldi, dolphin, rofi, fcitx"
echo -e " + install packages (by pamac)\n  - GoogleChrome, GoogleChrome_beta, VisualStudioCode"
echo -e "============================================================\n"
