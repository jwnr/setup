#!/bin/bash

echo -e "\n============================================================\n==== starting ==============================================\n============================================================"

echo 'Select OS'
PS3='Selected OS : '
select OS in 'EndeavourOS-i3wm' 'Manjaro-i3wm' 'cancel'

do
  if [ $REPLY -eq 1 ]; then
    # ==== mirror config
    # ==================================
    sed -i -e 's/^.*VerbosePkgLists.*$/#VerbosePkgLists/' /etc/pacman.conf
    reflector -l 16 -c JP,SG,TW --sort country -p https,rsync && pacman --noconfirm -Syyu
    eos-rankmirrors --sort age && eos-update --yay

    # ==== locale, time
    # ==================================
    sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf; source /etc/locale.conf

    # ==== display
    # ==================================
    #pacman -S sddm
    #systemctl enable sddm

    # ==== packs
    # ==================================
    # neovim jq nodejs-lts nodejs-lts-gallium bun
    # rxvt-unicode dolphin rofi
    #pacman -R --noconfirm
    pacman -S --needed --noconfirm unzip unrar webp-pixbuf-loader flameshot
    pacman -S --needed --noconfirm git nodejs npm deno; npm update -g npm; deno upgrade
    pacman -S --needed --noconfirm vivaldi vivaldi-ffmpeg-codecs fcitx5-im fcitx5-mozc
    yay -S --noconfirm google-chrome google-chrome-beta microsoft-edge-stable-bin visual-studio-code-bin
    pacman --noconfirm -Scc; yay --noconfirm -Scc
    #xdg-mime default microsoft-edge.desktop x-scheme-handler/http
    #xdg-mime default microsoft-edge.desktop x-scheme-handler/https

    break

  elif [ $REPLY -eq 2]; then
    # ==== mirror config
    # ==================================
    sed -i -e 's/^.*VerbosePkgLists.*$/VerbosePkgLists/' /etc/pacman.conf
    sed -i -e 's/^.*ParallelDownloads.*$/ParallelDownloads = 5/' /etc/pacman.conf
    pacman-mirrors -c Japan,Taiwan,Singapore && pacman --noconfirm -Syyu

    # ==== locale, time
    # ==================================
    sed -i -e 's/^.*ja_JP.UTF-8.*$/ja_JP.UTF-8 UTF-8/' /etc/locale.gen; locale-gen
    sed -i -e 's/^.*LANG.*$/LANG=ja_JP.UTF-8/' /etc/locale.conf; source /etc/locale.conf
    timedatectl set-ntp true
    #systemctl enable systemd-timesyncd
    #ntpdate ntp.nict.jp

    # ==== display
    # ==================================
    cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak
    mkdir /etc/lightdm/sl; chmod 777 /etc/lightdm/sl
    touch /etc/lightdm/sl/default.sh; chmod 755 /etc/lightdm/sl/default.sh; ln -snf /etc/lightdm/sl/default.sh /etc/lightdm/sl/sl.sh
    sed -i -e 's/^#display-setup-script=.*$/display-setup-script=\/etc\/lightdm\/sl\/sl.sh/' /etc/lightdm/lightdm.conf

    # ==== packs
    # ==================================
    # neovim jq nodejs-lts nodejs-lts-gallium bun
    pacman -R --noconfirm clipit palemoon pcmanfm
    pacman -S --needed --noconfirm unzip unrar webp-pixbuf-loader flameshot
    pacman -S --needed --noconfirm git nodejs npm deno; npm update -g npm; deno upgrade
    pacman -S --needed --noconfirm rxvt-unicode vivaldi vivaldi-ffmpeg-codecs dolphin rofi fcitx fcitx-configtool fcitx-mozc fcitx-qt5 fcitx-gtk3; chmod -R 777 /usr/share/fcitx/skin/default /usr/share/fcitx/mozc/icon
    pamac build --no-confirm google-chrome google-chrome-beta microsoft-edge-stable-bin visual-studio-code-bin
    pacman -Scc; pamac clean
    xdg-mime default microsoft-edge.desktop x-scheme-handler/http
    xdg-mime default microsoft-edge.desktop x-scheme-handler/https

    break

  else
    break
  fi
done

# ==== fonts
# ==================================
pacman --noconfirm -S otf-ipaexfont noto-fonts-emoji
ln -snf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
ln -snf ../conf.avail/70-no-bitmaps.conf /usr/share/fontconfig/conf.default/

# ==== hosts customize for Edge
# ==================================
echo -e \\n127.0.0.1 browser.events.data.msn.com\\n127.0.0.1 c.msn.com\\n127.0.0.1 sb.scorecardresearch.com\\n127.0.0.1 api.msn.com\\n >> /etc/hosts


echo -e "\n==== succeeded ============================================="
echo -e " + optimize mirror priority\n + sync package databases & upgrade local packages"
echo -e " + change locale (ja_JP.UTF-8)"
echo -e " + prepare font (install IPAex, disable bitmap font)"
echo -e " + remove package\n    - ClipIt"
echo -e " + install packages (by pacman)\n    - git, rxvt, unzip, unrar, Vivaldi, dolphin, rofi, fcitx, flameshot"
echo -e "    - Node.js(latest), npm, Deno(latest)"
echo -e " + install packages (by pamac)\n    - Chrome, Chrome beta, Edge, VS Code"
echo -e " + block some URL by adding hosts (for Edge)"
echo -e " +--------------------+------------------+"
echo -e " | screen recorder    | Vokoscreen       |"
echo -e " | video editor       | Shotcut          |"
echo -e " | Markdown editor    | Obsidian         |"
echo -e "============================================================\n"
