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

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, run the command shown in the terminal to add Homebrew to your PATH.

### 2. Install Git (if not already installed)

```bash
brew install git
```

### 3. Clone this repository

```bash
git clone https://github.com/BRTZL/dotfiles.git ~/.dotfiles
```

### 4. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 5. Install Oh My Zsh plugins

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### 6. Install Powerlevel10k theme

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 7. Run install script

```bash
~/.dotfiles/install.sh
```

This will:
- Create symlinks for all config files
- Optionally install Homebrew packages from Brewfile

### 8. Install a Nerd Font (for terminal icons)

Download and install a [Nerd Font](https://www.nerdfonts.com/font-downloads) (e.g., MesloLGS NF), then set it as your terminal font.

### 9. Restart your terminal

Open a new terminal window to apply all changes.

## Manual Commands

### Install only Homebrew packages

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

### Update Brewfile with currently installed packages

```bash
brew bundle dump --file=~/.dotfiles/Brewfile --force
```

## Updating

After making changes to your dotfiles:

```bash
cd ~/.dotfiles
git add .
git commit -m "Update dotfiles"
git push
```
