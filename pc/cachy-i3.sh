#!/bin/bash

echo -e "\n============================================================\n==== starting ==============================================\n============================================================"
echo -e '\n********************************************************'
echo -e '  + This script should be executed by normal user.\n  + Do not pipe to "| sh", download and execute.\n  + You need to do this task before this shell.\n        1. sudo xx (and enter passwd)'
echo -e '********************************************************\n'

read -sp "Enter root password: " pswd
echo

# == get key files & dotfiles
echo $pswd | sudo pacman -Syy
echo $pswd | sudo pacman -S --needed --noconfirm git
cd ~; curl -kOL -u wanner https://k.jwnr.net/ssh.tgz; tar xf ssh.tgz; rm -f ssh.tgz; chmod -R 400 .ssh/*
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
#echo $pswd | sudo -S sed -i -e 's/^.*VerbosePkgLists.*$/VerbosePkgLists/' /etc/pacman.conf
#echo $pswd | sudo -S sed -i -e 's/^.*ParallelDownloads.*$/ParallelDownloads = 5/' /etc/pacman.conf
#echo $pswd | sudo -S sed -i -e 's/^.*Color$/Color/' /etc/pacman.conf
#echo $pswd | sudo -S sed -i -e 's/^.*ILoveCandy$/ILoveCandy/' /etc/pacman.conf
echo $pswd | sudo -S reflector -l 16 -a 24 -c JP,TW,IN,KR -p https,rsync --sort score

# ==== locale, time
# ==================================
echo $pswd | sudo -S sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf
echo $pswd | sudo -S source /etc/locale.conf


# ==== remove packages & update
# ==================================
echo $pswd | sudo -S pacman --noconfirm -R vim nano micro wget firefox cachy-browser
echo $pswd | sudo -S pacman --noconfirm -Su


# ==== AUR package manager
# ==================================
#echo $pswd | sudo -S pacman --noconfirm -R yay
#echo $pswd | sudo -S pacman --noconfirm -S fakeroot debugedit
#cd ~/; git clone https://aur.archlinux.org/yay-bin.git yay-bin
#cd yay-bin; makepkg -si --noconfirm; cd ../; rm -rf yay-bin
#??echo $pswd | sudo -S sed -i -e 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -z -T0 -)/' /etc/makepkg.conf
#??echo $pswd | sudo -S sed -i -e 's/^#BUILDDIR/BUILDDIR/' /etc/makepkg.conf
#yay --sudoloop --noconfirm -Syua


# ==== packages
# ==================================
# neovim jq nodejs-lts nodejs-lts-gallium bun deno(deno upgrade)
# rxvt-unicode rofi webp-pixbuf-loader flameshot
# dolphin pcmanfm
# viewnior mupdf
# fossil remmina freerdp freerdp2
# vivaldi vivaldi-ffmpeg-codecs
paru -S --skipreview --sudoloop google-chrome google-chrome-beta microsoft-edge-stable-bin visual-studio-code-bin vivaldi vivaldi-ffmpeg-codecs
echo $pswd | sudo -S pacman -S --needed --noconfirm vi rsync unzip unrar exfatprogs fcitx5-im fcitx5-mozc
echo $pswd | sudo -S sh -c 'pacman -S --needed --noconfirm nodejs npm; npm update -g npm'
echo $pswd | sudo -S pacman --noconfirm -Scc
paru --noconfirm -Scc
#yay --noconfirm -Scc

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
#echo $pswd | sudo -S xdg-mime default microsoft-edge.desktop x-scheme-handler/https
#echo $pswd | sudo -S xdg-settings set default-web-browser microsoft-edge.desktop
#echo $pswd | sudo -S sed -i -e 's/^.*x-scheme-handler\/http=.*$/x-scheme-handler\/http=microsoft-edge.desktop;google-chrome.desktop;/' /usr/share/applications/mimeinfo.cache
#echo $pswd | sudo -S sed -i -e 's/^.*x-scheme-handler\/https=.*$/x-scheme-handler\/https=microsoft-edge.desktop;google-chrome.desktop;/' /usr/share/applications/mimeinfo.cache

# ==== fonts
# ==================================
echo $pswd | sudo -S pacman --noconfirm -S otf-ipaexfont noto-fonts-emoji
echo $pswd | sudo -S ln -snf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
echo $pswd | sudo -S ln -snf ../conf.avail/70-no-bitmaps.conf /usr/share/fontconfig/conf.default/
mkdir -p ~/.local/share; cp -rf ~/dots/files/fonts ~/.local/share/
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
#pacman -S sddm
#systemctl enable sddm

#cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak
#mkdir /etc/lightdm/sl; chmod 777 /etc/lightdm/sl
#touch /etc/lightdm/sl/default.sh; chmod 755 /etc/lightdm/sl/default.sh; ln -snf /etc/lightdm/sl/default.sh /etc/lightdm/sl/sl.sh
#sed -i -e 's/^#display-setup-script=.*$/display-setup-script=\/etc\/lightdm\/sl\/sl.sh/' /etc/lightdm/lightdm.conf


# == i3wm
# ==================================
#cp -f ~/.config/i3/config ~/.config/i3/config_bak; ln -snf ~/dots/_ccy/i3/config ~/.config/i3/config

# ==== other setting
# ==================================

## file manager
#cp -f ~/.config/dolphinrc ~/.config/dolphinrc_bak; ln -snf ~/dots/dir/dolphinrc ~/.config/dolphinrc


## hosts customize for Edge
#127.0.0.1 browser.events.data.msn.com
#127.0.0.1 c.msn.com
#127.0.0.1 sb.scorecardresearch.com
#127.0.0.1 api.msn.com   <- stopping
echo $pswd | sudo -S sh -c 'echo -e \\n127.0.0.1 browser.events.data.msn.com\\n127.0.0.1 c.msn.com\\n127.0.0.1 sb.scorecardresearch.com\\n >> /etc/hosts'

## GitHub
echo -e "[user]\n  email = 187tch@gmail.com\n  name  = wanner" >> ~/.gitconfig

## keymap
#cp ~/dots/.Xmodmap ~/

## wallpaper
cp ~/dots/files/wp/wp_blackblock_uw.jpg ~/Pictures/wallpaper.jpg

# ==================================


echo -e "\n==== succeeded ============================================="
echo -e " + sync package databases & upgrade local packages"
echo -e " + change locale (ja_JP.UTF-8)"
echo -e " + prepare font (install IPAex, disable bitmap font)"
echo -e " + remove package\n    - nothing"
echo -e " + install packages\n    - vi, rsync, git, unzip, unrar, Vivaldi, fcitx5, flameshot"
echo -e "    - Node.js(latest), npm"
echo -e " + install packages (AUR)\n    - Chrome, Chrome beta, Edge, VS Code"
echo -e " + block some URL by adding hosts (for Edge)"
echo -e " +------------------+--------------------------------------------+"
echo -e " | bun              | curl -fsSL https://bun.sh/install | bash   |"
echo -e " | screen recorder  | Vokoscreen                                 |"
echo -e " | video editor     | Shotcut                                    |"
echo -e " | Markdown editor  | Obsidian                                   |"
echo -e " +------------------+--------------------------------------------+"
echo -e "============================================================\n"
