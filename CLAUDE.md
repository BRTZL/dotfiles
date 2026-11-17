# Dotfiles Repository

## Structure

- `zsh/` - Modular zsh config: .zshrc loads plugins.zsh, exports.zsh, aliases.zsh, tools.zsh, keybindings.zsh, completions.zsh
- `git/` - .gitconfig and .gitignore_global
- `config/ghostty/` - Ghostty terminal config
- `agents/` - Global agent instructions: core.md + claude-tail.md / codex-tail.md, built into ~/.claude/CLAUDE.md and ~/.codex/AGENTS.md by build.sh
- `agents/skills/` - Shared skills; ~/.agents/skills links here and link-skills.sh links each into ~/.claude/skills and ~/.codex/skills. Third-party skills are listed in `agents/third-party-skills.txt`, installed by `install-skills.sh`, and git-ignored (add new ones to both files)
- `bin/` - Scripts symlinked into ~/.local/bin
- `Brewfile` - Homebrew packages, casks, and fonts
- `install.sh` - Symlink setup script

## Conventions

- Commit messages use conventional commits (e.g., `feat:`, `chore:`, `docs:`, `refactor:`)
- Single-line commit messages only (no multi-line bodies)
- New shell completions go in `zsh/completions.zsh`, not `.zshrc`
- New aliases go in `zsh/aliases.zsh`, not `.zshrc`
- New environment variables/PATH entries go in `zsh/exports.zsh`
- New tool initializations go in `zsh/tools.zsh`
- New completion `fpath` entries go in `zsh/plugins.zsh` (before oh-my-zsh runs compinit); never add another `compinit`
- Installers append to `.zshrc`; move what they add into the right module
- `.zshrc` is the entry point only — keep it minimal, delegate to module files
- This repo is public. Secrets and private values go in `.env` (git-ignored); add each new key, empty, to `.env.example`
