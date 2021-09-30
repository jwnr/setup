#!/bin/bash

echo -e "\n============================================================\n==== starting ==============================================\n============================================================"

# ==== mirror config
# ==================================
pacman-mirrors -c Japan,Taiwan,Singapore && pacman --noconfirm -Syyu

# ==== locale
# ==================================
sed -i -e 's/^.*ja_JP.UTF-8.*$/ja_JP.UTF-8 UTF-8/' /etc/locale.gen; locale-gen
sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf; source /etc/locale.conf

# ==== fonts
# ==================================
pacman --noconfirm -S otf-ipaexfont
ln -snf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/

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
