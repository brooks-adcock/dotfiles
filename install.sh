#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Migration guard: CLAUDE.md used to be a dotfiles symlink.
# It's now per-machine. Detect the old pattern and refuse to proceed.
if [ -L "$HOME/.claude/CLAUDE.md" ] && \
   [ "$(readlink "$HOME/.claude/CLAUDE.md")" = "$DOTFILES_DIR/claude/CLAUDE.md" ]; then
    echo ""
    echo "MIGRATION REQUIRED — install cannot continue."
    echo ""
    echo "~/.claude/CLAUDE.md is still a dotfiles symlink. The new pattern splits it:"
    echo "  preferences.md  → tracked in dotfiles, shared across machines"
    echo "  CLAUDE.md       → written per-machine, not tracked"
    echo ""
    echo "To migrate:"
    echo "  1. Read the current content:  cat ~/.claude/CLAUDE.md"
    echo "  2. Create a new ~/.claude/CLAUDE.md with just your machine-specific content"
    echo "  3. Add this line at the bottom:  @~/.claude/preferences.md"
    echo "  4. Re-run install.sh"
    echo ""
    echo "See the README for an example CLAUDE.md."
    echo ""
    exit 1
fi

link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "${dst}.bak"
        echo "backed up existing $(basename "$dst") → ${dst}.bak"
    fi
    ln -sf "$src" "$dst"
    echo "linked $dst → $src"
}

link "$DOTFILES_DIR/claude/commands"        "$HOME/.claude/commands"
link "$DOTFILES_DIR/claude/skills"          "$HOME/.claude/skills"
link "$DOTFILES_DIR/claude/templates"       "$HOME/.claude/templates"
link "$DOTFILES_DIR/claude/settings.json"   "$HOME/.claude/settings.json"
link "$DOTFILES_DIR/claude/preferences.md"  "$HOME/.claude/preferences.md"
# CLAUDE.md is written per-machine — not symlinked

echo "done"
