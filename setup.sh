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

    if [ -L "${target}" ]; then
        echo "Found old path symlink. delete ${target}"
        rm -i "${target}"
    fi
}

# alacritty
mkdir -p "$HOME/.config/alacritty"
delete_old "$HOME/.alacritty.yml"
mk_symlink "$HOME/dotfiles/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# git
delete_old "$HOME/.gitconfig"
delete_old "$HOME/.gitconfig-priv"
delete_old "$HOME/.gitignore"
mk_symlink "$HOME/dotfiles/git" "$HOME/.config/git"

# tmux
mkdir -p "$HOME/.config/tmux"
delete_old "$HOME/.tmux.conf"
mk_symlink "$HOME/dotfiles/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# zsh
delete_old "$HOME/.zsh"
mk_symlink "$HOME/dotfiles/zsh/.zshenv" "$HOME/.zshenv"
mk_symlink "$HOME/dotfiles/zsh/zsh" "$HOME/.config/zsh"

mk_symlink "$HOME/dotfiles/desktop/ghostty" "$HOME/.config/ghostty"
mk_symlink "$HOME/dotfiles/foot" "$HOME/.config/foot"
mk_symlink "$HOME/dotfiles/yazi" "$HOME/.config/yazi"

if [ "$1" = "niri" ]; then
    mk_symlink "$HOME/dotfiles/desktop/niri" "$HOME/.config/niri"
    mk_symlink "$HOME/dotfiles/desktop/waybar" "$HOME/.config/waybar"
    mk_symlink "$HOME/dotfiles/desktop/wofi" "$HOME/.config/wofi"
    mk_symlink "$HOME/dotfiles/desktop/dunst" "$HOME/.config/dunst"
    mk_symlink "$HOME/dotfiles/desktop/xdg-desktop-portal" "$HOME/.config/xdg-desktop-portal"
fi
