#!/bin/bash
# eos-update の noconfirm的オプション

echo -e "\n=========================================\n==== command started ====================\n=========================================\n"
echo 'Select OS'
PS3='Selected OS : '
select OS in 'EndeavourOS-i3wm' 'Manjaro-i3wm' 'cancel'

do
  if [ $REPLY -eq 1 ]; then

    break

  elif [ $REPLY -eq 2]; then

    break

  else
    break
  fi

  
done


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
