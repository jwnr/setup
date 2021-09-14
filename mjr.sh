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
pacman -S --needed --noconfirm git rxvt-unicode vivaldi dolphin rofi fcitx fcitx-configtool fcitx-mozc fcitx-qt5 fcitx-gtk3 otf-ipaexfont
cd /tmp
git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin/
makepkg -si


echo -e "\n==== succeeded ============================================="
echo -e " + optimize mirror priority\n + sync package databases & upgrade local packages"
echo -e " + change locale (ja_JP.UTF-8)\n + install packages (git, rxvt, vscode, vivaldi, dolphin, rofi, fcitx)\n + install font font (install IPA)"
echo -e "============================================================\n"
