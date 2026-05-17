#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

link "$DOTFILES_DIR/claude/commands"      "$HOME/.claude/commands"
link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILES_DIR/claude/CLAUDE.md"     "$HOME/.claude/CLAUDE.md"

echo "done"
