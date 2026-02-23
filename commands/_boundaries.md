# Workflow Boundaries

**This is a reference document, not a slash command.** It defines the three-tier boundary system for what AI agents may do autonomously, what requires user approval, and what is never permitted.

---

## ALWAYS (No Approval Needed)

These actions are safe and expected. Perform them without asking.

- **Run tests** before commits — use the project's cached test command
- **Run linters and formatters** after code changes
- **Check branch** — verify not on main before writing code
- **Read `current-work.md`** — load cached project context at phase start
- **Save artifacts** — write spec, test plan, research, implementation, and refactoring docs to `ai-context/`
- **Follow discovered patterns** — use the project's conventions for naming, structure, and style
- **Use the project's actual commands** — test, lint, build, and generate commands from Project Context
- **Commit at phase boundaries** — after tests are generated, after implementation passes, after refactoring

---

## ASK (Requires User Approval)

These actions involve judgment calls or irreversible decisions. Present options and wait for approval.

- **Approve specifications** — user must approve spec before moving to test phase
- **Approve refactoring strategies** — user must approve refactoring plan before execution
- **Add dependencies** — new packages, libraries, or external services
- **Modify schemas** — database migrations, API contract changes, type changes that affect other systems
- **Deviate from spec** — any implementation choice that doesn't match the approved specification
- **Skip phases** — user must explicitly agree to skip any workflow phase
- **Modify existing tests during implementation** — tests drive implementation, not the other way around
- **Mark requirements N/A** — if a spec requirement doesn't apply, flag it for user decision

---

## NEVER (Hard Stop)

These actions are prohibited. Do not perform them under any circumstances.

- **Commit secrets** — never commit `.env` files, API keys, credentials, or tokens
- **Write code on main** — all code changes happen on feature branches
- **Auto-invoke next phase via Skill tool** — context isolation requires `/clear` between phases; the user runs the next command
- **Skip test phase** — TDD requires tests before implementation
- **Modify tests to make them pass** — adjust implementation to match tests, never the reverse
- **Exceed context budget** — respect the per-phase context limits defined in each command
- **Push or force-push without explicit request** — the user decides when to push
- **Delete files outside `ai-context/`** without user confirmation — protect production code and configuration
- **Hardcode file paths** — discover paths from the repository; every codebase is different

---

## Usage

Each command file includes a `## Workflow Boundaries` section with phase-specific boundaries. This document is the canonical reference for the full boundary system.

When in doubt about whether an action is ALWAYS, ASK, or NEVER:
1. Check this document first
2. Check the phase-specific boundaries in the active command
3. If still unclear, **ASK the user** — it's always safe to ask
