#!/bin/bash

#Installation zsh

sudo pacman -S zsh
echo "zsh version:"
zsh --version
chsh -s $(which zsh)
