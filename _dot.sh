#!/bin/bash

echo -e "\n=========================================\n==== command started ====================\n=========================================\n"

#==== prepare ssh
#==================================
cd ~; curl -kOL -u wanner k.wnr.jp/ssh.tgz; tar xf ssh.tgz; rm -f ssh.tgz
chmod -R 400 .ssh/*

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

#== 全般設定
echo -e "\n#==== my commands ====\nexport TERM=screen.linux" >> ~/.bashrc
#== git
rm -f ~/.ssh/*; ln -snf ~/dots/dir/.ssh/config ~/.ssh/config
chmod 400 ~/dots/dir/.ssh/*/*
#== i3wm
cp -f ~/.i3/config ~/.i3/config_bak; ln -snf ~/dots/dir/.i3/config ~/.i3/config
#== fcitx設定
mkdir -p ~/.config/fcitx/conf; cp -f ~/dots/dir/.config/fcitx/config ~/.config/fcitx/; cp -f ~/dots/dir/.config/fcitx/profile ~/.config/fcitx/
ln -snf ~/dots/dir/.config/fcitx/conf/fcitx-classic-ui.config ~/.config/fcitx/conf/fcitx-classic-ui.config
mkdir -p ~/.config/mozc; cp -f ~/dots/dir/.config/mozc/config1.db ~/.config/mozc/
#== fcitxスキン
cp -f ~/dots/files/fcitx/default/* /usr/share/fcitx/skin/default/
cp -f ~/dots/files/fcitx/icon/* /usr/share/fcitx/mozc/icon/
#== font
cp -rf ~/dots/files/fonts ~/.local/share/
mkdir -p ~/.config/fontconfig; ln -snf ~/dots/dir/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
fc-cache -fv
#== display
mkdir -p ~/.screenlayout; touch ~/.screenlayout/a.sh; chmod 755 ~/.screenlayout/a.sh
ln -snf ~/.screenlayout/a.sh /etc/lightdm/sl/sl.sh
#== urxvt
#※.Xresourcesだとリンクが外れる
#xrdb -remove; xrdb -merge ~/.Xresources
cp -f ~/dots/urxvt_run.sh ~/; chmod 700 ~/urxvt_run.sh
#== nvim
ln -snf ~/dots/dir/.config/nvim/init.vim ~/.config/nvim/init.vim
#== Pcmanfm
mkdir -p ~/.config/pcmanfm/default; cp -f ~/dots/dir/.config/pcmanfm/default/pcmanfm.conf ~/.config/pcmanfm/default/

echo -e "\n==== command succeeded ========================\n+ prepare ssh\n+ download & deploy dot files"
echo -e "  ├ .config/\n  │  ├ fcitx/...\n  │  ├ fontconfig/...\n  │  ├ mozc/...\n  │  └ pcmanfm/...\n  ├ .i3/...\n  ├ .local/share/...    font files"
echo -e "  ├ .Xmodmap            keymap\n  ├ .gitconfig\n  ├ .gitignore\n  ├ .xprofile           for fcitx\n  └ urxvt_run.sh        terminal run script"
echo -e "\n+ display setting\n  after makeing xx.sh by arandr\n  ln -snf ~/.screenlayout/xx.sh /etc/lightdm/sl/sl.sh\n  (or paste code to ~/.screenlayout/a.sh)"
echo -e "\n        please reboot system\n===============================================\n"
