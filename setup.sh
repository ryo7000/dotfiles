#!/usr/bin/env bash

set -eu -o pipefail

function mk_symlink() {
    local src="${1}"
    local dst="${2}"

    if [ -e "${dst}" ]; then
        unlink "${dst}"
    fi
    ln -s "${src}" "${dst}"
    ls -l "${dst}"
}

function delete_old() {
    local target="${1}"

    if [ -e "${target}" ]; then
        echo "Found old path symlink. delete ${target}"
        rm -i "${target}"
    fi
}

# alacritty
mkdir -p "$HOME/.config/alacritty"
delete_old "$HOME/.alacritty.yml"
mk_symlink "$HOME/dotfiles/alacritty/.alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"

# git
delete_old "$HOME/.gitconfig"
delete_old "$HOME/.gitconfig-priv"
delete_old "$HOME/.gitignore"
mk_symlink "$HOME/dotfiles/git" "$HOME/.config/git"

# tmux
mk_symlink "$HOME/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"

# zsh
delete_old "$HOME/.zsh"
mk_symlink "$HOME/dotfiles/zsh/.zshenv" "$HOME/.zshenv"
mk_symlink "$HOME/dotfiles/zsh/zsh" "$HOME/.config/zsh"
