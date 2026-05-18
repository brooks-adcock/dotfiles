# Preferences

General preferences that apply on every machine.

## Package Management

- **Never use Homebrew** — use MacPorts, pip, npm, curl, or direct binaries instead
- MacPorts is the system package manager on personal machines

## Git Conventions

- **HEREDOC for commit messages** — always pass via `cat <<'EOF'` to preserve formatting
- **Stage by name** — always `git add file1 file2`, never `git add -A` or `git add .`
- **No compound cd commands** — never `cd /path && git ...` as a single command; use absolute paths or `git -C /path` instead — compound cd triggers permission prompts
- **No force push to main/master** without explicit instruction
- **Don't push** unless explicitly asked

## Claude Behavior

- **Auto-commit** — when asked to commit, do it without asking for confirmation
- **No trailing summaries** — don't recap what you just did at the end of a response; the diff speaks for itself
- **Terse by default** — short responses unless the task needs depth
- **No unsolicited refactoring** — fix what was asked, nothing more

## Identity

- GitHub: `brooks-adcock`
- Projects live in `~/Projects`
- Dotfiles tracked at `~/dotfiles` → `github.com:brooks-adcock/dotfiles`
