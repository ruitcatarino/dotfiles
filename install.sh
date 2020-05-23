#!/bin/bash

#Installation zsh

sudo pacman -S zsh
echo "zsh version:"
zsh --version
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
