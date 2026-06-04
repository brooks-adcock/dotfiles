# Shell aliases — tracked in dotfiles, sourced from ~/.zshrc by install.sh.

# Launch Claude Code with Opus + auto mode in one move.
# CLI flags override the org's managed remote-settings.json (which pins Sonnet
# and would otherwise win over ~/.claude/settings.json on every fresh session).
alias cco='claude --model claude-opus-4-8 --permission-mode auto'
