#!/bin/bash

echo -e "\n=========================================\n==== command started ====================\n=========================================\n"

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
cp -f ~/.i3/config ~/.i3/config_bak; ln -snf ~/dots/dir/.i3/config ~/.i3/config
#== fcitx設定
ln -snf ~/dots/dir/.config/fcitx/config ~/.config/fcitx/config
mkdir -p ~/.config/fcitx/conf; ln -snf ~/dots/dir/.config/fcitx/conf/fcitx-classic-ui.config ~/.config/fcitx/conf/fcitx-classic-ui.config
mkdir -p ~/.config/mozc; cp -f ~/dots/dir/.config/mozc/config1.db ~/.config/mozc/
#== fcitxスキン
cp -f ~/dots/files/fcitx/default/* /usr/share/fcitx/skin/default/
cp -f ~/dots/files/fcitx/icon/* /usr/share/fcitx/mozc/icon/
#== font
cp -rf ~/dots/files/fonts ~/.local/share/
mkdir -p ~/.config/fontconfig; ln -snf ~/dots/dir/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
fc-cache -fv
#== urxvt
#※.Xresourcesだとリンクが外れる
#xrdb -remove; xrdb -merge ~/.Xresources
cp -f ~/dots/urxvt_run.sh ~/; chmod 700 ~/urxvt_run.sh
#== Pcmanfm
mkdir -p ~/.config/pcmanfm/default; cp -f ~/dots/dir/.config/pcmanfm/default/pcmanfm.conf ~/.config/pcmanfm/default/

echo -e "\n==== command succeeded ========================\n+ prepare ssh\n+ download & deploy dot files"
echo -e "  ├ .config/\n  │  ├ fcitx/...\n  │  ├ fontconfig/...\n  │  ├ mozc/...\n  │  └ pcmanfm/...\n  ├ .i3/...\n  ├ .local/share/...    font files"
echo -e "  ├ .Xmodmap            keymap\n  ├ .gitconfig\n  ├ .gitignore\n  ├ .xprofile           for fcitx\n  └ urxvt_run.sh        terminal run script"
echo -e "\n        please reboot system\n===============================================\n"
