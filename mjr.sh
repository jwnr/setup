#!/bin/bash

echo -e "\n============================================================\n==== starting ==============================================\n============================================================"

# ==== mirror config
# ==================================
pacman-mirrors --country Japan,Taiwan,India,Singapore && pacman --noconfirm -Syyu

# ==== locale
# ==================================
sed -i -e 's/^.*ja_JP.UTF-8.*$/ja_JP.UTF-8 UTF-8/' /etc/locale.gen; locale-gen
sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf; source /etc/locale.conf

# ==== packs
# ==================================
pacman -S --needed --noconfirm snapd git rxvt-unicode vivaldi vivaldi-ffmpeg-codecs dolphin rofi fcitx fcitx-configtool fcitx-mozc fcitx-qt5 fcitx-gtk3 otf-ipaexfont
systemctl enable --now snapd.socket; ln -s /var/lib/snapd/snap /snap
snap install --classic code


echo -e "\n==== succeeded ============================================="
echo -e " + optimize mirror priority\n + sync package databases & upgrade local packages"
echo -e " + change locale (ja_JP.UTF-8)\n + install packages (snap, git, rxvt, vscode, vivaldi, dolphin, rofi, fcitx)\n + install font font (install IPA)"
echo -e "============================================================\n"
