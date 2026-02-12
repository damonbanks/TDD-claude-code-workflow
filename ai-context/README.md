# AI-Assisted Development Context

This directory contains all artifacts from the Test-First AI Development workflow.

## Structure

- **specs/**: Feature specifications with acceptance criteria
- **tests/**: Test plans and test generation documentation
- **research/**: Implementation research and codebase analysis
- **implementation/**: Implementation logs and notes
- **refactoring/**: Refactoring plans and optimization docs
- **bugs/**: Bug analysis documents for the bug fix workflow
- **current-work.md**: Tracks current work state, progress, and cached project discovery results
- **.workflow-config.yml.template**: Optional config to override auto-detection (copy to `.workflow-config.yml` to use)

## Workflow

1. `/start_work` → Discovers project context, caches it in `current-work.md`, routes to workflow
2. `/create_spec` → Creates spec in `specs/`
3. `/generate_tests` → Creates test plan in `tests/`
4. `/research_implementation` → Creates research doc in `research/`
5. `/implement` → Implements code, references research
6. `/refactor` → Optimizes code, saves plan to `refactoring/`
7. `/finish_work` → Cleans up artifacts after PR merge

## Project Discovery

When `/start_work` runs, it auto-detects your project's language, test framework, build/test/lint commands, git platform, and commit convention. These results are cached in `current-work.md` under a `## Project Context` section:

```markdown
## Project Context
- **Language(s)**: Go, TypeScript
- **Test framework**: go test + testify, Jest
- **Test command**: make test
- **Lint command**: make lint
- **Git platform**: GitHub
- **PR/MR command**: gh pr create
- **Commit convention**: Conventional Commits: type(scope): description
```

Every subsequent command reads this cached context instead of re-discovering. If a command is run without `/start_work`, it discovers and caches on its own.

To override auto-detection, copy `.workflow-config.yml.template` to `.workflow-config.yml`.

## File Naming Convention

`YYYY-MM-DD_TICKET-ID_feature-name_type.md` (with ticket)
`YYYY-MM-DD_feature-name_type.md` (without ticket)

- `TICKET-ID` = ticket identifier, any format (optional — omit if no ticket)
- `type` = one of: `spec`, `tests`, `research`, `implementation`, `refactoring`, `analysis` (bugs)

Examples:
- `2025-01-15_PROJ-123_user-authentication_spec.md`
- `2025-01-15_PROJ-123_user-authentication_tests.md`
- `2025-01-15_user-authentication_research.md` (no ticket)

## Context Management

Keep context under 60% by:
- Referencing these files with `@ai-context/...`
- Clearing context between phases
- Saving all outputs to this directory
