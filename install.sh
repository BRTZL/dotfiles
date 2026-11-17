#!/bin/bash
#
# install.sh — set up this machine from ~/.dotfiles.
#
# Links config files into $HOME, builds the agent instruction files,
# links agent skills, and optionally installs Homebrew packages.
# Safe to rerun: existing links are replaced, real files are backed up.
#
# Usage: ~/.dotfiles/install.sh

set -e

DOTFILES_DIR="$HOME/.dotfiles"


# ── Helpers ──────────────────────────────────────────────────────────────

# link_file <source> <destination>
# Points <destination> at <source>. A real file or folder already at
# <destination> is moved to <destination>.backup first.
link_file() {
    local src="$1"
    local dest="$2"

    # Old symlink: remove it so it can be replaced.
    if [ -L "$dest" ]; then
        rm "$dest"
    # Real file or folder: keep a backup instead of overwriting it.
    elif [ -e "$dest" ]; then
        echo "Backing up $dest to $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "Linked: $dest -> $src"
}


echo "Installing dotfiles..."


# ── Shell (zsh) ──────────────────────────────────────────────────────────

link_file "$DOTFILES_DIR/zsh/.zshrc"    "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"


# ── Git ──────────────────────────────────────────────────────────────────

link_file "$DOTFILES_DIR/git/.gitconfig"        "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"


# ── Ghostty terminal ─────────────────────────────────────────────────────

link_file "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"


# ── Scripts (put on PATH via ~/.local/bin) ───────────────────────────────

link_file "$DOTFILES_DIR/bin/agent-notify" "$HOME/.local/bin/agent-notify"


# ── Local secrets (.env, never committed) ────────────────────────────────

# First run: start .env from the template, readable only by you.
if [ ! -f "$DOTFILES_DIR/.env" ]; then
    cp "$DOTFILES_DIR/.env.example" "$DOTFILES_DIR/.env"
    chmod 600 "$DOTFILES_DIR/.env"
    echo "Created .env from .env.example: fill in AGENT_NTFY_TOPIC"
fi


# ── Coding agents (Claude Code, Codex) ───────────────────────────────────

# Writes ~/.claude/CLAUDE.md and ~/.codex/AGENTS.md from agents/*.md.
"$DOTFILES_DIR/agents/build.sh"

# Installs third-party skills (third-party-skills.txt), then links
# every skill in agents/skills into ~/.agents, ~/.claude and ~/.codex.
"$DOTFILES_DIR/agents/install-skills.sh"


# ── Homebrew packages (asks first) ───────────────────────────────────────

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
