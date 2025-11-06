#!/bin/bash

echo -e "\n============================================================\n==== starting ==============================================\n============================================================"

if [ -z "$SUDO_USER" ]; then
  echo -e '\n********************************************************'
  echo "  error: run this script as 'sudo ./xx.sh'"
  echo -e '********************************************************\n'
  exit 1
fi

echo -e '\n********************************************************'
echo -e ' + Do not pipe to "| sh", download and execute.'
echo -e '********************************************************\n'


PS3="Select repository type (q=quit): "
options=("EndeavourOS" "Manjaro, Mabox" "CachyOS" "Artix")
select opt in "${options[@]}"; do
  case "$REPLY" in
    q) break ;;
    '' ) echo "error" ;;
    *[!1-4]* ) echo " invalid value" ;;
    *)
      if (( REPLY >= 1 && REPLY <= ${#options[@]} )); then
        dstp=$REPLY
        echo
        break
      else
        echo " invalid value"
      fi
      ;;
  esac
done


echo -e "\n\n==== preparing =============================================\n"

# ==== update db (force)
pacman -Syy
# ==== install essential packages
pacman -S --noconfirm --needed git
# ==== remove packages
pacman -R --noconfirm vim
pacman -R --noconfirm nano
pacman -R --noconfirm micro
pacman -R --noconfirm firefox
pacman -R --noconfirm cachy-browser
pacman -R --noconfirm falkon

# ==== [normal user] get key files & dotfiles
sudo -u "$SUDO_USER" sh -c 'cd ~; curl -kOL -u wanner https://k.jwnr.net/ssh.tgz; tar xf ssh.tgz; rm -f ssh.tgz; chmod -R 400 .ssh/*'
sudo -u "$SUDO_USER" git clone git@github.com:jwnr/dots.git
# ==== [normal user] SSH
sudo -u "$SUDO_USER" sh -c 'rm -f ~/.ssh/*; ln -snf ~/dots/dir/.ssh/config ~/.ssh/config; chmod 400 ~/dots/dir/.ssh/*/*'

# ==== [Artix] add Arch support
if [ $dstp -eq 4 ]; then
  pacman -S --noconfirm artix-archlinux-support
  cp /etc/pacman.conf /etc/pacman.conf.arch
  echo -e \\n\\n\# ---- Artix Arch Support ----\\n[extra]\\nInclude = /etc/pacman.d/mirrorlist-arch\\n\\n\ | sudo tee -a /etc/pacman.conf.arch
  #echo -e [community]\\n\Include = /etc/pacman.d/mirrorlist-arch\\n\\n | sudo tee -a /etc/pacman.conf.arch
  pacman-key --populate archlinux
  #pacman --config /etc/pacman.conf.arch -Sy
fi


echo -e "\n==== ranking mirrors =======================================\n"

sed -i -e 's/^.*VerbosePkgLists.*$/VerbosePkgLists/' /etc/pacman.conf
sed -i -e 's/^.*ParallelDownloads.*$/ParallelDownloads = 5/' /etc/pacman.conf
sed -i -e 's/^.*Color$/Color/' /etc/pacman.conf
sed -i -e 's/^.*ILoveCandy$/ILoveCandy/' /etc/pacman.conf

if [ $dstp -eq 2 ]; then
  pacman -S --noconfirm --needed pacman-mirrors
  pacman-mirrors -c Japan,Taiwan,Singapore --api --proto https
  # pacman-mirrors --fasttrack 8 --api --proto https

else
  if [ $dstp -eq 4 ]; then
    pacman --config /etc/pacman.conf.arch -Sy --noconfirm --needed reflector
  else
    pacman -S --noconfirm --needed reflector
  fi

  reflector --latest 8 --age 24 -c JP,TW,IN,KR --protocol https,rsync --sort score

fi


echo -e "\n==== AUR package manager ===================================\n"

if [ $dstp -eq 2 ]; then
  sudo -u "$SUDO_USER" pamac update --no-confirm --aur

else
  pacman -R --noconfirm yay
  pacman -S --noconfirm --needed fakeroot base-devel debugedit
  sudo -u "$SUDO_USER" sh -c 'cd ~/; git clone https://aur.archlinux.org/yay-bin.git yay-bin'
  sudo -u "$SUDO_USER" sh -c 'cd yay-bin; makepkg -si --noconfirm; cd ../; rm -rf yay-bin'
  sudo -u "$SUDO_USER" yay -Sya --noconfirm --sudoloop --save

fi

# ????
#??echo $pswd | sudo -S sed -i -e 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -z -T0 -)/' /etc/makepkg.conf
#??echo $pswd | sudo -S sed -i -e 's/^#BUILDDIR/BUILDDIR/' /etc/makepkg.conf


echo -e "\n==== locale, time ==========================================\n"
# ==== locale, time
sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf
source /etc/locale.conf


echo -e "\n==== packages ==============================================\n"
# ==== packages
# ==================================
# jq nodejs-lts nodejs-lts-gallium bun deno(deno upgrade)
# gvfs ??
# rxvt-unicode rofi webp-pixbuf-loader
# dolphin pcmanfm
# brave    vivaldi vivaldi-ffmpeg-codecs
# viewnior mupdf flameshot
# fossil remmina freerdp freerdp2

pacman -S --noconfirm --needed vi rsync zip unzip unrar exfatprogs fcitx5-im fcitx5-mozc
pacman -S --noconfirm --needed remmina freerdp gparted flameshot
#sh -c 'pacman -S --noconfirm --needed nodejs npm; npm update -g npm'
pacman --noconfirm -Scc

if [ $dstp -eq 2 ]; then
  #sudo -u "$SUDO_USER" pamac build --no-confirm microsoft-edge-stable-bin google-chrome visual-studio-code-bin
  sudo -u "$SUDO_USER" pamac build --no-confirm brave-bin google-chrome visual-studio-code-bin
  sudo -u "$SUDO_USER" pamac clean --no-confirm -u -b -k 1 
else
  #sudo -u "$SUDO_USER" yay -S --noconfirm --needed microsoft-edge-stable-bin google-chrome visual-studio-code-bin
  sudo -u "$SUDO_USER" yay -S --noconfirm --needed brave-bin google-chrome visual-studio-code-bin
  sudo -u "$SUDO_USER" yay --noconfirm -Scc
fi
#sudo -u "$SUDO_USER" paru -S --skipreview --sudoloop --noconfirm google-chrome microsoft-edge-stable-bin visual-studio-code-bin
#sudo -u "$SUDO_USER" paru --noconfirm -Scc


# ==== fonts
# ==================================
pacman --noconfirm -S otf-ipaexfont noto-fonts-emoji
ln -snf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
ln -snf ../conf.avail/70-no-bitmaps.conf /usr/share/fontconfig/conf.default/
sudo -u "$SUDO_USER" mkdir -p ~/.local/share; cp -rf ~/dots/files/fonts ~/.local/share/
sudo -u "$SUDO_USER" mkdir -p ~/.config/fontconfig; ln -snf ~/dots/dir/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
sudo -u "$SUDO_USER" fc-cache -fv

# ==== fcitx
# ==================================
# /usr/share/icons/hicolor/00x00/apps/
# 32 48 128
echo -e "export XMODIFIERS=@im=fcitx\nexport GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\n" >> /etc/profile

mkdir /tmp/zxcv; rsync -a ~/dots/files/fcitx5/* /tmp/zxcv/
#cp -f /tmp/zxcv/icon/* /usr/share/icons/hicolor/32x32/apps/
cp -f /tmp/zxcv/icon48/* /usr/share/icons/hicolor/48x48/apps/
#cp -f /tmp/zxcv/icon128/* /usr/share/icons/hicolor/128x128/apps/
rm -rf /tmp/zxcv

sudo -u "$SUDO_USER" rsync -a ~/dots/end/dir/.config/fcitx5/* ~/.config/fcitx5/
sudo -u "$SUDO_USER" rsync -a ~/dots/end/dir/.config/mozc/* ~/.config/mozc/

# ==== other setting
# ==================================
## hosts customize for Edge
echo -e \\n127.0.0.1 browser.events.data.msn.com\\n127.0.0.1 c.msn.com\\n127.0.0.1 sb.scorecardresearch.com\\n >> /etc/hosts

## GitHub
sudo -u "$SUDO_USER" sh -c 'echo -e "[user]\n  email = 187tch@gmail.com\n  name  = wanner" >> ~/.gitconfig'

## wallpaper
sudo -u "$SUDO_USER" cp ~/dots/files/wp/wp_blackblock_uw.jpg ~/Pictures/wallpaper.jpg

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
