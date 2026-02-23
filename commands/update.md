Update the TDD Claude Code Workflow commands by pulling the latest changes from the repo.

Run:
```bash
git -C "$(readlink -f ~/.claude/commands/..)" pull
```

Report the result to the user — whether it updated, was already up to date, or failed.
