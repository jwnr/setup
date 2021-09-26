#!/bin/bash

echo -e "\n=========================================\n==== command started ====================\n=========================================\n"

cd ~

#==== prepare ssh
#==================================
cd ~; curl -kOL -u wanner k.wnr.jp/ssh.tgz; tar xf ssh.tgz
chmod 400 .ssh/id_rsa; rm -f .ssh/id_rsa.pub; rm -f ssh.tgz

#==== download & deploy
#==================================
git clone git@github.com:jwnr/dots.git
cd ~/dots
for f in .??*
do
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".gitignore" ]] && continue
  [[ "$f" == ".DS_Store" ]] && continue
  
  ln -snf ~/dots/"$f" ~/
done

#== i3
cp ~/.i3/config ~/.i3/config_bak
ln -snf ~/dots/dir/.i3/config ~/.i3/config
#== fcitx
# ※profileはリンクが外れる
mkdir -p ~/.config/fcitx
ln -snf ~/dots/dir/.config/fcitx/config ~/.config/fcitx/config
ln -snf ~/dots/dir/.config/fcitx/profile ~/.config/fcitx/profile
#== font
cp -rf ~/dots/files/fonts ~/.local/share/
mkdir -p ~/.config/fontconfig
ln -snf ~/dots/dir/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
fc-cache -fv
#== Vivaldi
#mkdir ~/.config/vivaldi
#ln -snf ~/dots/dir/.config/vivaldi/Default ~/.config/vivaldi/
#touch ~/.config/vivaldi/"First Run"
#== urxvt
# ※.Xresourcesはリンクが外れる
#xrdb -remove
#xrdb -merge ~/.Xresources
cp ~/dots/urxvt_run.sh ~/
chmod 700 ~/urxvt_run.sh

echo -e "\n==== command succeeded ==================\ninstall packages\n"
echo -e "download & deploy dot files\n"
echo -e " ├ .Xmodmap            key customize\n ├ .Xresources         urxvt setting\n ├ .xprofile           for fcitx\n ├ .config/\n │  ├ fcitx/...        fcitx\n │  └ fontconfig/...   font\n └ .i3/...             i3\n"
echo -e "\n     please reboot system\n=========================================\n"
