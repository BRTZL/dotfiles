# Zsh completions configuration

# opencode completions
_opencode_yargs_completions() {
  local reply
  local si=$IFS
  IFS=$'\n'
  reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" opencode --get-yargs-completions "${words[@]}"))
  IFS=$si
  if [[ ${#reply} -gt 0 ]]; then
    _describe 'values' reply
  else
    _default
  fi
}
compdef _opencode_yargs_completions opencode

# bun completions
[ -s "/Users/bartuozel/.bun/_bun" ] && source "/Users/bartuozel/.bun/_bun"
