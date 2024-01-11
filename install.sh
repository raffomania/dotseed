#!/bin/bash

set -euxo pipefail

cp .zshrc .zshenv ~
echo "export PATH=\$PATH:$(dirname "$0")/bin" >> ~/.zshenv
touch ~/.zshrc.local ~/.zshenv.local

if [[ ! "$SHELL" == *zsh ]]; then
    chsh -s /usr/bin/zsh
fi

mkdir -p ~/.config/starship
cp starship.toml ~/.config/starship