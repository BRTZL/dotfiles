# p10k instant prompt (keep at top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Dotfiles directory
DOTFILES="$HOME/.dotfiles/zsh"

# Load modular configs
source "$DOTFILES/plugins.zsh"
source $ZSH/oh-my-zsh.sh
source "$DOTFILES/exports.zsh"
source "$DOTFILES/aliases.zsh"
source "$DOTFILES/tools.zsh"
source "$DOTFILES/keybindings.zsh"
source "$DOTFILES/completions.zsh"

# p10k theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
