#!/bin/sh

sudo apt install bspwm sxhkd polybar compton rofi dunst nitrogen ranger cmus redshift i3lock xorg

cp -r ~/dotfiles/dot_config/* ~/.config/
cp ~/dotfiles/.zshrc ~/
cp ~/dotfiles/.xinitrc ~/

chmod u+x ~/.config/bspwm/bspwmrc