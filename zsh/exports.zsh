# Environment variables and PATH configuration

# Editors
export REACT_EDITOR=code

# Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Flutter
export PATH=$HOME/flutter/bin:$PATH

# PostgreSQL
export PATH=$PATH:/opt/homebrew/opt/libpq/bin

# JetBrains Toolbox
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Local binaries
export PATH="$PATH:$HOME/.local/bin"
