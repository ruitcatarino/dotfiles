#!/bin/sh

sudo apt install bspwm sxhkd polybar compton rofi dunst nitrogen ranger cmus redshift i3lock xorg zathura mpv jq streamlink zsh curl

cp -r ./dot_config/* ~/.config/
cp ./.zshrc ~/
cp ./.xinitrc ~/

chmod u+x ~/.config/bspwm/bspwmrc

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/krathalan/wtwitch ~/wtwitch