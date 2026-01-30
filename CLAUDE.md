# Dotfiles Repository

## Structure

- `zsh/` - Modular zsh config: .zshrc loads plugins.zsh, exports.zsh, aliases.zsh, tools.zsh, keybindings.zsh, completions.zsh
- `git/` - .gitconfig and .gitignore_global
- `config/ghostty/` - Ghostty terminal config
- `Brewfile` - Homebrew packages, casks, and fonts
- `install.sh` - Symlink setup script

## Conventions

- Commit messages use conventional commits (e.g., `feat:`, `chore:`, `docs:`, `refactor:`)
- Single-line commit messages only (no multi-line bodies)
- New shell completions go in `zsh/completions.zsh`, not `.zshrc`
- New aliases go in `zsh/aliases.zsh`, not `.zshrc`
- New environment variables/PATH entries go in `zsh/exports.zsh`
- New tool initializations go in `zsh/tools.zsh`
- `.zshrc` is the entry point only — keep it minimal, delegate to module files
