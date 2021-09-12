#!/bin/bash

echo -e "\n================================================\n==== command start =============================\n================================================\n"
echo "upgrade all packages ? ( y / n )"
read x
echo -e "==== started ===============================================\n"

#=== mirror config
#==================================
pacman-mirrors --country Japan,Taiwan,India,Singapore

if [ $x = 'y' ]; then
  pacman --noconfirm -Syyu
else
  pacman --noconfirm -Syy
fi

#=== locale
#==================================
sed -i -e 's/^.*ja_JP.UTF-8.*$/ja_JP.UTF-8 UTF-8/' /etc/locale.gen; locale-gen
sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf; source /etc/locale.conf

#=== packs
#==================================
pacman -S git rxvt-unicode dolphin rofi fcitx fcitx-configtool fcitx-mozc fcitx-qt5 fcitx-gtk3 otf-ipaexfont --noconfirm

echo -e "\n==== succeeded =============================================\n"
echo -e " + optimize mirror priority\n"
if [ $x = 'y' ]; then
  echo -e " + upgrade all packages\n"
fi
echo -e " + change locale (ja_JP.UTF-8)\n + install packages (git, rxvt, dolphin, rofi, fcitx)\n + install font font (install IPA)\n"
echo -e "============================================================\n"
