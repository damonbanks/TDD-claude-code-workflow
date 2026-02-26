# TDD Claude Code Workflow

A structured Test-Driven Development workflow for AI-assisted development:
- Claude Code via slash commands
- Codex via a dedicated `tdd-workflow` skill

## What This Is

This repo provides reusable workflow assets and an `ai-context/` directory structure that guide you through a strict TDD cycle:

**Spec → Test → Research → Implement → Refactor**

Each phase produces artifacts that feed into the next, with context management built in to keep Claude effective across long workflows.

**Design principle:** Each phase runs in a fresh context (`/clear` between phases). Phases communicate only through artifact files on disk — this prevents the LLM's reasoning from bleeding across phase boundaries, preserving TDD's role separation.

## Claude Commands

| Command | Purpose |
|---------|---------|
| `/start_work` | Begin a work session — routes to the right workflow |
| `/create_spec` | Generate a specification with acceptance criteria |
| `/generate_tests` | Create failing tests from the spec (TDD red state) |
| `/research_implementation` | Analyze the codebase and plan implementation |
| `/implement` | Write code to make tests pass (TDD green state) |
| `/refactor` | Optimize and clean up while keeping tests green |
| `/finish_work` | Clean up artifacts after PR merge |

## Setup

### Global install (recommended)

Clone the repo and run the install script:

```bash
git clone https://github.com/damonbanks/TDD-claude-code-workflow.git ~/.claude/TDD-claude-code-workflow
~/.claude/TDD-claude-code-workflow/install.sh --target claude
```

To install the Codex skill:

```bash
~/.claude/TDD-claude-code-workflow/install.sh --target codex
```

To pin a specific release:

```bash
~/.claude/TDD-claude-code-workflow/install.sh --target claude v1.0.2
~/.claude/TDD-claude-code-workflow/install.sh --target codex v1.0.2
```

To update later:

```bash
~/.claude/TDD-claude-code-workflow/update.sh --target claude          # latest main
~/.claude/TDD-claude-code-workflow/update.sh --target claude v1.0.2   # specific release
~/.claude/TDD-claude-code-workflow/update.sh --target codex           # latest main skill
~/.claude/TDD-claude-code-workflow/update.sh --target codex v1.0.2    # specific skill release
```

Notes:
- Claude installs command files into `~/.claude/commands/`.
- Codex installs skill `tdd-workflow` into `~/.codex/skills/tdd-workflow`.
- `--target` defaults to `claude` if omitted.

## Quick Start

### Claude Code (Slash Commands)

1. Install Claude commands:
   ```bash
   ~/.claude/TDD-claude-code-workflow/install.sh --target claude
   ```
2. In your project, ensure `ai-context/` exists.
3. Start with:
   ```text
   /start_work
   ```
4. Follow phases:
   ```text
   /create_spec -> /generate_tests -> /research_implementation -> /implement -> /refactor -> /finish_work
   ```

### Codex (Skill)

1. Install Codex skill:
   ```bash
   ~/.claude/TDD-claude-code-workflow/install.sh --target codex
   ```
2. Restart Codex so the skill is loaded.
3. Start with a prompt such as:
   ```text
   Use tdd-workflow to start work on PROJ-123 add user authentication.
   ```
4. Continue by prompting the same phase progression (spec -> tests -> research -> implement -> refactor -> finish).

## Codex Prompt Examples

After installation, invoke the skill directly in Codex prompts. Example requests:

```text
Use tdd-workflow to start work on PROJ-123 add user authentication.
Use tdd-workflow to create a spec for password reset.
Use tdd-workflow to generate failing happy-path tests from ai-context/specs/2026-02-26_PROJ-123_password-reset_spec.md.
```

The skill definition is in `skills/tdd-workflow/` and reuses the same phase contracts as the Claude command set.

### Per-project install

Copy files directly into your project:

```bash
# From your project root
cp -r /path/to/TDD-claude-code-workflow/commands/ .claude/commands/
cp -r /path/to/TDD-claude-code-workflow/skills/tdd-workflow/ .codex/skills/tdd-workflow/
cp -r /path/to/TDD-claude-code-workflow/ai-context/ ai-context/
```

Use Claude commands when working in Claude Code, or the `tdd-workflow` skill prompts when working in Codex.

## Compatibility

This workflow auto-detects your project's setup at runtime — no configuration required.

### Languages
Go, TypeScript/JavaScript, Rust, Python, Java/Kotlin, C#/.NET, Ruby, PHP, Elixir, Swift, C/C++, and any other language with a discoverable test framework.

### Ticket Systems
Jira (`PROJ-123`), GitHub/GitLab Issues (`#42`), Shortcut (`sc-12345`), Linear, YouTrack, or any format. Tickets are optional — the workflow works without them.

### Git Platforms
GitHub, GitLab, Bitbucket, Azure DevOps. PR/MR creation adapts to your platform's CLI or web interface.

### Commit Conventions
Auto-detected from your git history and commitlint config. Supports Conventional Commits, ticket-prefixed, and custom formats.

### Automatic Project Discovery

When you run `/start_work`, Claude runs a discovery protocol that detects your project's tooling and conventions:

- **Language & framework** from manifest files (`package.json`, `go.mod`, `Cargo.toml`, etc.)
- **Test framework & conventions** from existing test files (framework, location, naming patterns, assertion style)
- **Build/test/lint commands** from `Makefile`, `package.json` scripts, CI config, or README
- **Git platform** from remote URL and CI/CD config files
- **Commit convention** from recent git history and commitlint config

Results are cached in `ai-context/project-context.md`. This file **persists across features** — `/finish_work` does not delete it. Every subsequent command (`/create_spec`, `/generate_tests`, `/implement`, etc.) reads this cached context so it uses the correct test command, commit format, and platform tooling — no re-discovery needed.

If a command is run without `/start_work` first, it will run discovery on its own and cache the results.

The discovery protocol is defined in `commands/_project_discovery.md` — it's a reference document, not a slash command.

To override auto-detection, copy `ai-context/.workflow-config.yml.template` to `ai-context/.workflow-config.yml` and configure the settings you want to control explicitly.

## Supported Work Types

- **New Feature** — Full 5-phase TDD cycle with approval gates
- **Bug Fix** — Streamlined 4-phase workflow (analyze → reproduce → fix → verify)
- **Resume Work** — Pick up where you left off using saved artifacts

## How It Works

- **Read-only exploration** is used for spec, bug analysis, research, and refactor assessment — exploration only, requires approval (via AskUserQuestion) before proceeding
- **Implementation** is used for writing tests, code, and executing refactors
- Artifacts are saved to `ai-context/` with a consistent naming convention: `YYYY-MM-DD_TICKET-ID_feature-name_type.md` (ticket portion is optional)
- **Context isolation** between phases — run `/clear` before each new phase so the LLM approaches each role (spec author, test writer, researcher, implementer, refactorer) with fresh perspective. Phases communicate only through artifact files in `ai-context/`

See [`ai-context/WORKFLOW_GUIDE.md`](ai-context/WORKFLOW_GUIDE.md) for the full guide.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- Codex CLI (for `--target codex` skill install)
