#!/bin/bash

set -euxo pipefail

dotseed_dir=$(realpath -e "$(dirname "${BASH_SOURCE[0]}")")
cd "$dotseed_dir"

cp .zshrc .zshenv ~
echo "export PATH=\$PATH:$dotseed_dir/bin" >> ~/.zshenv
touch ~/.zshrc.local ~/.zshenv.local

if [[ ! "$SHELL" == *zsh ]]; then
    chsh -s /usr/bin/zsh
fi

mkdir -p ~/.config/starship
cp starship.toml ~/.config/starship