#!/bin/bash

echo -e "\n============================================================\n==== starting ==============================================\n============================================================"
echo -e '\n*****************************************************'
echo -e '  + You need to do "sudo xx" before this shell.\n        Have you done it?\n  + This shell cannot pipe to "| sh".\n        Download and execute, ok?.'
echo -e '*****************************************************\n'

read -sp "Enter root password: " pswd
echo

# == get key files & dotfiles
cd ~; curl -kOL -u wanner https://k.jwnr.net/ssh.tgz; tar xf ssh.tgz; rm -f ssh.tgz; chmod -R 400 .ssh/*
git clone git@github.com:jwnr/dots.git
# == SSH
rm -f ~/.ssh/*; ln -snf ~/dots/dir/.ssh/config ~/.ssh/config
chmod 400 ~/dots/dir/.ssh/*/*

echo -e "\n==== command started =======================================\n"


# ==== mirror config
# ==================================
#sed -i -e 's/^.*VerbosePkgLists.*$/#VerbosePkgLists/' /etc/pacman.conf
echo $pswd | sudo -S sh -c 'reflector -l 16 -c JP,SG,TW --sort country -p https,rsync && pacman --noconfirm -Syyu'
echo $pswd | sudo -S sh -c 'eos-rankmirrors --sort age && eos-update --yay'

# ==== locale, time
# ==================================
echo $pswd | sudo -S sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf; source /etc/locale.conf

# ==== packages
# ==================================
# neovim jq nodejs-lts nodejs-lts-gallium bun deno(deno upgrade)
# rxvt-unicode dolphin rofi webp-pixbuf-loader flameshot
#echo $pswd | sudo -S pacman -R --noconfirm ~~~
echo $pswd | sudo -S pacman -S --needed --noconfirm unzip unrar fcitx5-im fcitx5-mozc
echo $pswd | sudo -S sh -c 'pacman -S --needed --noconfirm git nodejs npm; npm update -g npm'
echo $pswd | sudo -S pacman -S --needed --noconfirm vivaldi vivaldi-ffmpeg-codecs
yay -S --noconfirm google-chrome google-chrome-beta microsoft-edge-stable-bin visual-studio-code-bin
echo $pswd | sudo -S pacman --noconfirm -Scc; yay --noconfirm -Scc


#### default browser
# microsoft-edge.desktop
# google-chrome.desktop
# google-chrome-beta.desktop
# vivaldi-stable.desktop
# firefox.desktop
## command (doesn't work)
#xdg-mime default xxxx.desktop x-scheme-handler/https
#xdg-settings set default-web-browser xxxx.desktop
## add "x-scheme-handler/https=xxxx.desktop;xxxx.desktop;"
#~/.config/mimeapps.list
echo $pswd | sudo -S sed -i -e 's/^.*x-schme-handler\/http=.*$/x-schme-handler\/http=microsoft-edge.desktop;google-chrome.desktop;/' /usr/share/applications/mimeinfo.cache;
echo $pswd | sudo -S sed -i -e 's/^.*x-schme-handler\/https=.*$/x-schme-handler\/https=microsoft-edge.desktop;google-chrome.desktop;/' /usr/share/applications/mimeinfo.cache;

# ==== fonts
# ==================================
echo $pswd | sudo -S pacman --noconfirm -S otf-ipaexfont noto-fonts-emoji
echo $pswd | sudo -S ln -snf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
echo $pswd | sudo -S ln -snf ../conf.avail/70-no-bitmaps.conf /usr/share/fontconfig/conf.default/
cp -rf ~/dots/files/fonts ~/.local/share/
mkdir -p ~/.config/fontconfig; ln -snf ~/dots/dir/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
fc-cache -fv

# ==== fcitx
# ==================================
echo $pswd | sudo -S sh -c 'echo -e "export XMODIFIERS=@im=fcitx\nexport GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\n" >> /etc/profile'
rsync -a ~/dots/end/dir/.config/fcitx5/* ~/.config/fcitx5/
rsync -a ~/dots/end/dir/.config/mozc/* ~/.config/mozc/

# ==== display
# ==================================

# == i3wm
# ==================================
cp -f ~/.config/i3/config ~/.config/i3/config_bak; ln -snf ~/dots/end/dir/.config/i3/config ~/.config/i3/config
cp -f ~/.config/i3/i3blocks.conf ~/.config/i3/i3blocks.conf_bak; ln -snf ~/dots/end/dir/.config/i3/i3blocks.conf ~/.config/i3/i3blocks.conf

# ==== other setting
# ==================================
# hosts customize for Edge
echo $pswd | sudo -S sh -c 'echo -e \\n127.0.0.1 browser.events.data.msn.com\\n127.0.0.1 c.msn.com\\n127.0.0.1 sb.scorecardresearch.com\\n127.0.0.1 api.msn.com\\n >> /etc/hosts'
# GitHub
echo -e "[user]\n  email = 187tch@gmail.com\n  name  = wanner" >> ~/.gitconfig
# terminal
echo -e "\n#==== my commands ====\nexport TERM=xterm-256color" >> ~/.bashrc
# keymap
cp ~/dots/.Xmodmap ~/


echo -e "\n==== succeeded ============================================="
echo -e " + optimize mirror priority\n + sync package databases & upgrade local packages"
echo -e " + change locale (ja_JP.UTF-8)"
echo -e " + prepare font (install IPAex, disable bitmap font)"
echo -e " + remove package\n    - nothing"
echo -e " + install packages (by pacman)\n    - git, rxvt, unzip, unrar, Vivaldi, dolphin, rofi, fcitx, flameshot"
echo -e "    - Node.js(latest), npm, Deno(latest)"
echo -e " + install packages (by yay)\n    - Chrome, Chrome beta, Edge, VS Code"
echo -e " + block some URL by adding hosts (for Edge)"
echo -e " +--------------------+------------------+"
echo -e " | screen recorder    | Vokoscreen       |"
echo -e " | video editor       | Shotcut          |"
echo -e " | Markdown editor    | Obsidian         |"
echo -e " +--------------------+------------------+"
echo -e "============================================================\n"
