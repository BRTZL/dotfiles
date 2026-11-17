#!/bin/sh
#
# build.sh — generate the global instruction files for coding agents.
#
#   core.md + claude-tail.md  ->  ~/.claude/CLAUDE.md
#   core.md + codex-tail.md   ->  ~/.codex/AGENTS.md
#
# core.md holds the rules both agents share; each tail holds the
# agent-specific part. Edit those files, then rerun this script.
# Never edit the generated files: the next build overwrites them.

set -e

# Folder this script lives in (~/.dotfiles/agents).
AGENTS_DIR="$(cd "$(dirname "$0")" && pwd)"

# First line of each generated file, so nobody edits it by mistake.
HEADER="<!-- Generated from ~/.dotfiles/agents by build.sh. Edit core.md or a *-tail.md there, then rerun build.sh. -->"


# build <tail file> <output file>
# Writes: header, blank line, core.md, then the tail.
build() {
    tail_file="$1"
    output="$2"

    mkdir -p "$(dirname "$output")"
    {
        echo "$HEADER"
        echo
        cat "$AGENTS_DIR/core.md" "$AGENTS_DIR/$tail_file"
    } > "$output"
}


build claude-tail.md "$HOME/.claude/CLAUDE.md"
build codex-tail.md  "$HOME/.codex/AGENTS.md"

echo "Wrote ~/.claude/CLAUDE.md and ~/.codex/AGENTS.md"
