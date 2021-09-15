#!/bin/bash

echo -e "\n============================================================\n==== starting ==============================================\n============================================================"

# ==== mirror config
# ==================================
pacman-mirrors --country Japan,Taiwan,India,Singapore && pacman --noconfirm -Syyu

# ==== locale
# ==================================
sed -i -e 's/^.*ja_JP.UTF-8.*$/ja_JP.UTF-8 UTF-8/' /etc/locale.gen; locale-gen
sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf; source /etc/locale.conf

# ==== fonts
# ==================================
pacman -S otf-ipaexfont --noconfirm
ln -snf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/

# ==== packs
# ==================================
pacman -S git rxvt-unicode vivaldi vivaldi-ffmpeg-codecs dolphin rofi fcitx fcitx-configtool fcitx-mozc fcitx-qt5 fcitx-gtk3 --needed --noconfirm
pamac build google-chrome google-chrome-beta visual-studio-code-bin --no-confirm
pacman -Scc; pamac clean


echo -e "\n==== succeeded ============================================="
echo -e " + optimize mirror priority\n + sync package databases & upgrade local packages"
echo -e " + change locale (ja_JP.UTF-8)"
echo -e " + prepare font (install IPA, disable bitmap font)"
echo -e " + install packages (by pacman)\n  - git, rxvt, Vivaldi, dolphin, rofi, fcitx"
echo -e " + install packages (by pamac)\n  - GoogleChrome, GoogleChrome_beta, VisualStudioCode"
#echo -e "## install VSCode (not root)\nmkdir ~/tmp; cd ~/tmp; git clone https://aur.archlinux.org/visual-studio-code-bin.git\ncd visual-studio-code-bin/; makepkg -csi\ncd ~; rm -rf tmp"
echo -e "============================================================\n"
