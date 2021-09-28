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

#== i3wm
cp ~/.i3/config ~/.i3/config_bak
ln -snf ~/dots/dir/.i3/config ~/.i3/config
#== fcitx
mkdir -p ~/.config/fcitx/conf
ln -snf ~/dots/dir/.config/fcitx/config ~/.config/fcitx/config
#cp ~/dots/dir/.config/fcitx/profile ~/.config/fcitx/profile
ln -snf ~/dots/dir/.config/fcitx/conf/fcitx-classic-ui.config ~/.config/fcitx/conf/fcitx-classic-ui.config
mkdir -p ~/.config/mozc
cp ~/dots/dir/.config/mozc/config1.db ~/.config/mozc/config1.db
#== font
cp -rf ~/dots/files/fonts ~/.local/share/
mkdir -p ~/.config/fontconfig
ln -snf ~/dots/dir/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
fc-cache -fv
#== urxvt
# ※.Xresourcesはリンクが外れる
#xrdb -remove
#xrdb -merge ~/.Xresources
cp ~/dots/urxvt_run.sh ~/
chmod 700 ~/urxvt_run.sh

#== Pcmanfm
mkdir -p ~/.config/pcmanfm/default
cp ~/dots/dir/.config/pcmanfm/default/pcmanfm.conf ~/.config/pcmanfm/default/pcmanfm.conf
#== Vivaldi
mkdir -p ~/.config/vivaldi/Default
cp ~/dots/dir/.config/vivaldi/Default/Preferences ~/.config/vivaldi/Default/Preferences
touch ~/.config/vivaldi/"First Run"

echo -e "\n==== command succeeded ========================\n+ install packages"
echo -e "+ download & deploy dot files\n  ├ .Xmodmap            key customize\n  ├ .xprofile           for fcitx\n  ├ .config/\n  │  ├ fcitx/...        input jp (fcitx)"
echo -e "  │  ├ fontconfig/...   font config\n  │  └ mozc/...         input jp (mozc)\n  ├ .i3/...             i3wm\n  ├ .local/share/...    font files\n  └ urxvt_run.sh        terminal run script"
echo -e "\n        please reboot system\n===============================================\n"
