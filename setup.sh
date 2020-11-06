#!/bin/bash


#==================================
#===== root
#==================================

#=== mirror config
#==================================
#sed -i -e '/^Method.*/d' /etc/pacman-mirrors.conf;sed -i -e '/^OnlyCountry.*/d' /etc/pacman-mirrors.conf;
#echo -e \\nMethod = rank\\nOnlyCountry = Japan >> /etc/pacman-mirrors.conf && pacman-mirrors --fasttrack && pacman -Syyu

#=== locale
#==================================
sudo sed -i -e 's/^.*ja_JP.UTF-8.*$/ja_JP.UTF-8 UTF-8/' /etc/locale.gen; locale-gen;
sudo sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf; source /etc/locale.conf;

#=== packs    dbus...?
#==================================
sudo pacman -S git --noconfirm
sudo pacman -S fcitx fcitx-configtool fcitx-mozc fcitx-qt5 fcitx-gtk3 otf-ipaexfont --noconfirm
rm /etc/fonts/conf.d/70-yes-bitmaps.conf; ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/; fc-cache -fv;

#==================================
#===== user
#==================================
exit;

#=== x
#==================================
cd ~; git clone https://github.com/j-wanner/dots.git;
cp dots/file/fonts/HackGen /usr/share/fonts/;
echo -e "export LANG=\"ja_JP.UTF-8\"\nexport XMODIFIERS=\"@im=fcitx\"\nexport XMODIFIER=\"@im=fcitx\"\nexport GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport DefaultIMModule=fcitx" > ~/.xprofile
echo -e "\nexport GTK_IM_MODULE=fcitx\nexport XMODIFIERS=@im=fcitx\nexport QT_IM_MODULE=fcitx" >> ~/.bashrc
#echo -e "\n\nexec --no-startup-id fcitx" >> ~/.i3/config
