# dotfiles

My macOS dotfiles.

## Structure

```
~/.dotfiles/
├── Brewfile                 # Homebrew packages
├── config/ghostty/config    # Ghostty terminal config
├── git/.gitconfig           # Git configuration
├── git/.gitignore_global    # Global gitignore
├── install.sh               # Installation script
└── zsh/
    ├── .zshrc               # Main zsh config
    ├── .p10k.zsh            # Powerlevel10k theme
    ├── aliases.zsh          # Aliases
    ├── exports.zsh          # Environment variables & PATH
    ├── keybindings.zsh      # macOS-style key bindings
    ├── plugins.zsh          # Oh-my-zsh plugins
    └── tools.zsh            # Tool initializations (nvm, rbenv, etc.)
```

## Installation

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone dotfiles
git clone https://github.com/BRTZL/dotfiles.git ~/.dotfiles

# Run install script
~/.dotfiles/install.sh
```

## Manual Package Install

```bash
brew bundle --file=~/.dotfiles/Brewfile
```
