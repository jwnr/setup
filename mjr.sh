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
touch /etc/lightdm/sl/default.sh; chmod 755 /etc/lightdm/sl/default.sh; ln -snf /etc/lightdm/sl/default.sh /etc/lightdm/sl/sl.sh
sed -i -e 's/^#display-setup-script=.*$/display-setup-script=\/etc\/lightdm\/sl\/sl.sh/' /etc/lightdm/lightdm.conf

# ==== packs
# ==================================
# neovim
pacman -R --noconfirm clipit
pacman -S --needed --noconfirm git rxvt-unicode unzip vivaldi vivaldi-ffmpeg-codecs dolphin rofi fcitx fcitx-configtool fcitx-mozc fcitx-qt5 fcitx-gtk3; chmod -R 777 /usr/share/fcitx/skin/default /usr/share/fcitx/mozc/icon
pacman -S --needed --noconfirm nodejs-lts-gallium npm deno; deno upgrade
pamac build --no-confirm google-chrome google-chrome-beta microsoft-edge-stable-bin visual-studio-code-bin
pacman -Scc; pamac clean

echo -e "\n==== succeeded ============================================="
echo -e " + optimize mirror priority\n + sync package databases & upgrade local packages"
echo -e " + change locale (ja_JP.UTF-8)"
echo -e " + prepare font (install IPAex, disable bitmap font)"
echo -e " + remove package\n    - ClipIt"
echo -e " + install packages (by pacman)\n    - git, rxvt, unzip, Vivaldi, dolphin, rofi, fcitx"
echo -e "    - Node.js(16), npm, Deno(latest)"
echo -e " + install packages (by pamac)\n    - Chrome, Chrome beta, Edge, VS Code"
echo -e "============================================================\n"
