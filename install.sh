#!/bin/bash

#Installation zsh

sudo apt install -y zsh
echo "zsh version:"
zsh --version
chsh -s $(which zsh)
