#!/bin/bash

echo -e "\n============================================================\n==== starting ==============================================\n============================================================"
echo -e '\n*****************************************************'
echo -e '  + This script should be executed by normal user.\n  + You need to do 2 tasks before this shell.\n        1. sudo xx (and hit pass)\n        2. yay -S pamac-aur\n  + This shell cannot pipe to "| sh".\n    Download and execute.'
echo -e '*****************************************************\n'

read -sp "Enter root password: " pswd
echo

# == get key files & dotfiles
cd ~; curl -kOL -u wanner https://k.jwnr.net/ssh.tgz; tar xf ssh.tgz; rm -f ssh.tgz; chmod -R 400 .ssh/*
echo $pswd | sudo -S sh -c 'pacman -S --needed --noconfirm git'
git clone git@github.com:jwnr/dots.git
# == SSH
rm -f ~/.ssh/*; ln -snf ~/dots/dir/.ssh/config ~/.ssh/config
chmod 400 ~/dots/dir/.ssh/*/*

echo -e "\n==== command started =======================================\n"


# ==== mirror config
# ==================================
# /etc/pacman.conf
#   - VerbosePkgLists
#   - ParallelDownloads = 5
#   - Color
#   - ILoveCandy
echo $pswd | sudo -S sh -c 'reflector -l 16 -a 24 -c JP,TW,IN,KR -p https,rsync --sort score && pacman --noconfirm -Syyu'
echo $pswd | sudo -S sh -c 'eos-rankmirrors --sort age && eos-update --yay'

# ==== locale, time
# ==================================
echo $pswd | sudo -S sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf; source /etc/locale.conf


# ==== package manager
# ==================================
echo $pswd | sudo -S pacman -R --noconfirm yay
cd ~/;git clone https://aur.archlinux.org/yay-bin.git yay-bin;cd yay-bin
makepkg -si --noconfirm;cd ../;rm -rf yay-bin
sed -i -e 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -z -T0 -)/' /etc/makepkg.conf
sed -i -e 's/^#BUILDDIR/BUILDDIR/' /etc/makepkg.conf

# ==== packages
# ==================================
# neovim jq nodejs-lts nodejs-lts-gallium bun deno(deno upgrade)
# rxvt-unicode dolphin rofi webp-pixbuf-loader flameshot
echo $pswd | sudo -S pacman -S --needed --noconfirm unzip unrar fcitx5-im fcitx5-mozc
echo $pswd | sudo -S sh -c 'pacman -S --needed --noconfirm fossil nodejs npm; npm update -g npm'
echo $pswd | sudo -S pacman -S --needed --noconfirm vivaldi vivaldi-ffmpeg-codecs
echo $pswd | sudo -S pamac build --no-confirm google-chrome google-chrome-beta microsoft-edge-stable-bin visual-studio-code-bin
echo $pswd | sudo -S pacman --noconfirm -Scc

# ==== default browser
# ==================================
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
echo $pswd | sudo -S sed -i -e 's/^.*x-scheme-handler\/http=.*$/x-scheme-handler\/http=microsoft-edge.desktop;google-chrome.desktop;/' /usr/share/applications/mimeinfo.cache
echo $pswd | sudo -S sed -i -e 's/^.*x-scheme-handler\/https=.*$/x-scheme-handler\/https=microsoft-edge.desktop;google-chrome.desktop;/' /usr/share/applications/mimeinfo.cache

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
# /usr/share/icons/hicolor/00x00/apps/
# 32 48 128
echo $pswd | sudo -S sh -c 'echo -e "export XMODIFIERS=@im=fcitx\nexport GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\n" >> /etc/profile'
rsync -a ~/dots/files/fcitx5/icon/* /tmp/zxcv/
echo $pswd | sudo -S sh -c 'cp -f /tmp/zxcv/* /usr/share/icons/hicolor/32x32/apps/'
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
# wallpaper
cp ~/dots/files/wp/wp_blackblock_uw.jpg ~/Pictures/wallpaper.jpg


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
