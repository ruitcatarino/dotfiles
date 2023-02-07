#!/bin/sh

sudo apt install bspwm sxhkd polybar compton rofi dunst nitrogen ranger cmus redshift i3lock xorg zathura mpv jq streamlink

cp -r ./dot_config/* ~/.config/
cp ./.zshrc ~/
cp ./.xinitrc ~/

chmod u+x ~/.config/bspwm/bspwmrc

git clone https://github.com/krathalan/wtwitch ~/wtwitch