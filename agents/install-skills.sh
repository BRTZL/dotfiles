#!/bin/sh
#
# install-skills.sh — install third-party skills, then link all skills.
#
#   1. For each line in third-party-skills.txt, install the skill with
#      `npx skills add` unless it is already in agents/skills.
#   2. Run link-skills.sh so Claude Code and Codex see every skill.
#
# Safe to rerun: installed skills are skipped. Needs Node (npx); without
# it, step 1 is skipped with a note and your own skills still get linked.

set -e

# Folder this script lives in (~/.dotfiles/agents).
AGENTS_DIR="$(cd "$(dirname "$0")" && pwd)"
LIST="$AGENTS_DIR/third-party-skills.txt"


# ── 1. Install third-party skills ────────────────────────────────────────

# link-skills.sh first, so ~/.agents/skills points into this repo and
# `npx skills add -g` installs straight into agents/skills.
"$AGENTS_DIR/link-skills.sh" > /dev/null

if ! command -v npx > /dev/null 2>&1; then
    echo "Skipping third-party skills: npx not found. Install Node, then rerun $0"
else
    # Skip comments and blank lines; each line is "<repo> <skill>".
    grep -v '^[[:space:]]*\(#\|$\)' "$LIST" | while read -r repo skill; do

        if [ -f "$AGENTS_DIR/skills/$skill/SKILL.md" ]; then
            echo "Skill $skill: already installed"
            continue
        fi

        echo "Skill $skill: installing from $repo"

        # -g: user-level (~/.agents/skills)   -y: no prompts
        # Output goes to a log, shown only if the install fails.
        log=$(mktemp)
        if ! npx -y skills add "$repo" -g -s "$skill" -a claude-code -a codex -y < /dev/null > "$log" 2>&1; then
            cat "$log"
            echo "Skill $skill: install failed (see above)"
        fi
        rm -f "$log"

        # Guard: a third-party skill must never be committed.
        if ! git -C "$AGENTS_DIR" check-ignore -q "skills/$skill"; then
            echo "Warning: agents/skills/$skill is not in .gitignore. Add it before committing."
        fi
    done
fi


# ── 2. Link every skill into Claude Code and Codex ───────────────────────

"$AGENTS_DIR/link-skills.sh"
