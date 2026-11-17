# Tool initializations

# NVM
export NVM_DIR="$HOME/.nvm"
# A child shell can inherit an NVM bin directory behind Homebrew. Remove it
# before initialization so `nvm use` can place the selected version first.
path=("${(@)path:#${NVM_DIR}/versions/node/*/bin}")
source $(brew --prefix nvm)/nvm.sh

# rbenv
eval "$(rbenv init - zsh)"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# EAS autocomplete
EAS_AC_ZSH_SETUP_PATH="$HOME/Library/Caches/eas-cli/autocomplete/zsh_setup" && test -f $EAS_AC_ZSH_SETUP_PATH && source $EAS_AC_ZSH_SETUP_PATH
