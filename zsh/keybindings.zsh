# macOS-style word navigation
bindkey "^[[1;3D" backward-word  # Option + Left
bindkey "^[[1;3C" forward-word   # Option + Right
bindkey "^[b" backward-word      # Alt + b (fallback)
bindkey "^[f" forward-word       # Alt + f (fallback)

# Line navigation (Cmd + Arrow)
bindkey "^[OH" beginning-of-line  # Cmd + Left / Home
bindkey "^[OF" end-of-line        # Cmd + Right / End

# Delete word
bindkey "^[^?" backward-kill-word  # Option + Backspace
