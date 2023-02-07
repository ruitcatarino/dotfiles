#!/bin/sh

sudo apt install bspwm sxhkd polybar compton rofi dunst nitrogen ranger cmus redshift i3lock xorg zathura

cp -r ./dot_config/* ~/.config/
cp ./.zshrc ~/
cp ./.xinitrc ~/

chmod u+x ~/.config/bspwm/bspwmrc