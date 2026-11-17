#!/bin/sh
#
# link-skills.sh — make the skills in this repo available to every agent.
#
#   ~/.agents/skills         -> ~/.dotfiles/agents/skills   (one shared folder)
#   ~/.claude/skills/<name>  -> ~/.agents/skills/<name>     (Claude Code)
#   ~/.codex/skills/<name>   -> ~/.agents/skills/<name>     (Codex)
#
# Safe to rerun. Third-party skills (git-ignored) are installed with
# `npx skills add <source>` and get linked the same way once present.

set -e

# Folder holding the skills (~/.dotfiles/agents/skills).
SKILLS_DIR="$(cd "$(dirname "$0")" && pwd)/skills"


# ── 1. Shared folder ─────────────────────────────────────────────────────

mkdir -p "$HOME/.agents" "$HOME/.claude/skills" "$HOME/.codex/skills"

# A real ~/.agents/skills folder (not a link) is moved aside, not deleted.
if [ -d "$HOME/.agents/skills" ] && [ ! -L "$HOME/.agents/skills" ]; then
    mv "$HOME/.agents/skills" "$HOME/.agents/skills.backup"
    echo "Backed up ~/.agents/skills to ~/.agents/skills.backup"
fi

ln -sfn "$SKILLS_DIR" "$HOME/.agents/skills"


# ── 2. One link per skill, per agent ─────────────────────────────────────

count=0
for skill_dir in "$SKILLS_DIR"/*/; do
    name=$(basename "$skill_dir")

    # Relative link, so it keeps working if $HOME moves.
    ln -sfn "../../.agents/skills/$name" "$HOME/.claude/skills/$name"
    ln -sfn "../../.agents/skills/$name" "$HOME/.codex/skills/$name"

    count=$((count + 1))
done

echo "Linked $count skills into ~/.claude/skills and ~/.codex/skills"
