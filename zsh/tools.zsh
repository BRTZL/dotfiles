# Tool initializations

# NVM
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# rbenv
eval "$(rbenv init - zsh)"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# EAS autocomplete
EAS_AC_ZSH_SETUP_PATH="$HOME/Library/Caches/eas-cli/autocomplete/zsh_setup" && test -f $EAS_AC_ZSH_SETUP_PATH && source $EAS_AC_ZSH_SETUP_PATH
