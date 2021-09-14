#!/bin/bash

echo -e "\n============================================================\n==== starting ==============================================\n============================================================\n"

# ==== mirror config
# ==================================
pacman-mirrors --country Japan,Taiwan,India,Singapore

# pacman --noconfirm -Syyu
pacman --noconfirm -Syy

# ==== locale
# ==================================
sed -i -e 's/^.*ja_JP.UTF-8.*$/ja_JP.UTF-8 UTF-8/' /etc/locale.gen; locale-gen
sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf; source /etc/locale.conf

# ==== packs
# ==================================
pacman -S git rxvt-unicode dolphin rofi fcitx fcitx-configtool fcitx-mozc fcitx-qt5 fcitx-gtk3 otf-ipaexfont --noconfirm

echo -e "\n==== succeeded =============================================\n"
echo -e " + optimize mirror priority\n + sync package databases & upgrade local packages\n"
echo -e " + change locale (ja_JP.UTF-8)\n + install packages (git, rxvt, dolphin, rofi, fcitx)\n + install font font (install IPA)\n"
echo -e "============================================================\n"
