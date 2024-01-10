#!/bin/bash

set -euxo pipefail

cp .zshrc .zshenv ~
touch ~/.zshrc.local ~/.zshenv.local

if [[ ! "$SHELL" =~ "zsh$" ]]; then
    chsh -s /usr/bin/zsh
fi