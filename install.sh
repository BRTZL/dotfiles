#!/bin/bash

# Dotfiles installation script
# Run this on a new machine to set up symlinks

DOTFILES_DIR="$HOME/.dotfiles"

echo "Installing dotfiles..."

# Function to backup and symlink
link_file() {
    local src="$1"
    local dest="$2"

    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        echo "Backing up $dest to $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    if [ -L "$dest" ]; then
        rm "$dest"
    fi

    ln -s "$src" "$dest"
    echo "Linked: $dest -> $src"
}

# Create necessary directories
mkdir -p "$HOME/.config/ghostty"

# Zsh
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Git
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# Ghostty
link_file "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"

# Install Homebrew packages
if command -v brew &> /dev/null && [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo ""
    read -p "Install Homebrew packages from Brewfile? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew bundle --file="$DOTFILES_DIR/Brewfile"
    fi
fi

echo ""
echo "Done! Open a new terminal to apply changes."
