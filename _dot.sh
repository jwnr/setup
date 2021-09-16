#!/bin/bash

echo -e "\n=========================================\n==== command started ====================\n=========================================\n"


#==== download
#==================================
#cd ~; git clone https://github.com/jwnr/dots.git
cd ~; git clone git@github.com:jwnr/dots.git

#==== deploy
#==================================
cd ~/dots
for f in .??*
do
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".gitignore" ]] && continue
  #[[ "$f" == ".DS_Store" ]] && continue
  
  ln -snfv ~/dots/"$f" ~/
done

#== i3
cp ~/.i3/config ~/.i3/config_bak
ln -snf ~/dots/dir/.i3/config ~/.i3/config
#== fcitx
mkdir -p ~/.config/fcitx
ln -snf ~/dots/dir/.config/fcitx/config ~/.config/fcitx/config
ln -snf ~/dots/dir/.config/fcitx/profile ~/.config/fcitx/profile
#== font
cp -rf ~/dots/files/fonts ~/.local/share/
mkdir -p ~/.config/fontconfig
ln -snf ~/dots/dir/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
ln -snf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
fc-cache -fv
#== Vivaldi
ln -snf ~/dots/dir/.config/vivaldi/Default ~/.config/vivaldi/
touch ~/.config/vivaldi/"First Run"

xrdb -remove
xrdb -merge ~/.Xresources


echo -e "\n==== command succeeded ==================\ninstall packages\n"
echo -e "download & deploy dot files\n"
echo -e " ├ .Xmodmap            key customize\n ├ .Xresources         urxvt setting\n ├ .xprofile           for fcitx\n ├ .config/\n │  ├ fcitx/...        fcitx\n │  └ fontconfig/...   font\n └ .i3/...             i3\n"
echo -e "\n     please reboot system\n=========================================\n"
