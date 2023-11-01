#!/bin/bash

# SSH > 記述先が.bashrcで良いかどうか

echo -e "\n=========================================\n==== command started ====================\n=========================================\n"
echo 'Select OS'
PS3='Selected OS : '
select OS in 'EndeavourOS-i3wm' 'Manjaro-i3wm' 'cancel'

do
  #==== get key files & dotfiles
  #==================================
  cd ~; curl -kOL -u wanner https://k.jwnr.net/ssh.tgz; tar xf ssh.tgz; rm -f ssh.tgz
  chmod -R 400 .ssh/*
  git clone git@github.com:jwnr/dots.git

  #== SSH
  echo -e "\n#==== my commands ====\nexport TERM=xterm-256color" >> ~/.bashrc
  rm -f ~/.ssh/*; ln -snf ~/dots/dir/.ssh/config ~/.ssh/config
  chmod 400 ~/dots/dir/.ssh/*/*
  #== my font
  cp -rf ~/dots/files/fonts ~/.local/share/
  mkdir -p ~/.config/fontconfig; ln -snf ~/dots/dir/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
  fc-cache -fv
  #== GitHub
  echo -e "[user]\n  email = 187tch@gmail.com\n    name = wanner" >> ~/.bashrc
  #== i3wm
  cp -f ~/.i3/config ~/.i3/config_bak; ln -snf ~/dots/dir/.i3/config ~/.i3/config


  if [ $REPLY -eq 1 ]; then
    #== fcitx設定
    #mkdir -p ~/.config/fcitx/conf; cp -f ~/dots/dir/.config/fcitx/config ~/.config/fcitx/; cp -f ~/dots/dir/.config/fcitx/profile ~/.config/fcitx/
    #ln -snf ~/dots/dir/.config/fcitx/conf/fcitx-classic-ui.config ~/.config/fcitx/conf/fcitx-classic-ui.config
    #mkdir -p ~/.config/mozc; cp -f ~/dots/dir/.config/mozc/config1.db ~/.config/mozc/

    break

  elif [ $REPLY -eq 2]; then

    #== キーマップ
    ln -snf ~/dots/.Xmodmap ~/
    #== sway
    #cp -f ~/.sway/config ~/.sway/config_bak; ln -snf ~/dots/dir/.sway/config ~/.sway/config
    #== fcitx設定
    echo -e "export LANG='ja_JP.UTF-8'\nexport XMODIFIERS='@im=fcitx'\nexport XMODIFIER='@im=fcitx'\n" >> ~/.xprofile
    echo -e "export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport DefaultIMModule=fcitx\n" >> ~/.xprofile
    mkdir -p ~/.config/fcitx/conf; cp -f ~/dots/dir/.config/fcitx/config ~/.config/fcitx/; cp -f ~/dots/dir/.config/fcitx/profile ~/.config/fcitx/
    ln -snf ~/dots/dir/.config/fcitx/conf/fcitx-classic-ui.config ~/.config/fcitx/conf/fcitx-classic-ui.config
    mkdir -p ~/.config/mozc; cp -f ~/dots/dir/.config/mozc/config1.db ~/.config/mozc/
    #== fcitxスキン
    cp -f ~/dots/files/fcitx/default/* /usr/share/fcitx/skin/default/
    cp -f ~/dots/files/fcitx/icon/* /usr/share/fcitx/mozc/icon/
    #== default browser
    sed -i -e 's/userapp-Pale Moon/microsoft-edge/' ~/.config/mimeapps.list
    #== display
    mkdir -p ~/.screenlayout; touch ~/.screenlayout/a.sh; chmod 755 ~/.screenlayout/a.sh
    ln -snf ~/.screenlayout/a.sh /etc/lightdm/sl/sl.sh
    #== urxvt
    #xrdb -remove; xrdb -merge ~/.Xresources  <-  link get away...
    cp -f ~/dots/urxvt_run.sh ~/; chmod 700 ~/urxvt_run.sh
    #== nvim
    #ln -snf ~/dots/dir/.config/nvim/init.vim ~/.config/nvim/init.vim
    #== Pcmanfm
    mkdir -p ~/.config/pcmanfm/default; cp -f ~/dots/dir/.config/pcmanfm/default/pcmanfm.conf ~/.config/pcmanfm/default/

    break
  else
  
    break
  fi
done



echo -e "\n==== command succeeded ========================\n+ prepare ssh\n+ download & deploy dot files"
echo -e "  ├ .config/\n  │  ├ fcitx/...\n  │  ├ fontconfig/...\n  │  ├ mozc/...\n  │  └ pcmanfm/...\n  ├ .i3/...\n  ├ .local/share/...    font files"
echo -e "  ├ .Xmodmap            keymap\n  ├ .gitconfig\n  ├ .gitignore\n  ├ .xprofile           for fcitx\n  └ urxvt_run.sh        terminal run script"
echo -e "\n+ display setting\n  cat ~/dots/dir/.screenlayout/xx.sh > ~/.screenlayout/a.sh"
echo -e "\n  (or make xx.sh by arandr and )ln -snf ~/.screenlayout/xx.sh /etc/lightdm/sl/sl.sh"
echo -e "\n        please reboot system\n===============================================\n"
