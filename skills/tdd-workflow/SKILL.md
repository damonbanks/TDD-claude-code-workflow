---
name: tdd-workflow
description: Structured artifact-driven TDD workflow for Codex with strict phase gates and context isolation. Use when planning or implementing new features or bug fixes that should follow Start -> Spec -> Tests -> Research -> Implement -> Refactor -> Finish with state tracked in ai-context/current-work.md.
---

# TDD Workflow

Run disciplined TDD using phase isolation and file-based handoffs in `ai-context/`.

## Core Rules

- Keep phase isolation: treat each phase as independent work based on artifacts, not prior conversation memory.
- Never write tests or implementation on `main` or `master`.
- Keep `ai-context/current-work.md` up to date after every phase.
- Use `ai-context/project-context.md` as the source of truth for test/build/lint commands.
- Do not skip Test-before-Implement unless the user explicitly approves bypassing TDD.

## Required Inputs

- Feature or bug description from the user.
- Optional ticket ID.
- Existing repository conventions discovered in `ai-context/project-context.md`.

## Helper Scripts

Use these scripts for deterministic workflow operations:

- `scripts/check_branch.sh`
  - Block code-writing phases if on `main`/`master`.
- `scripts/make_artifact_name.sh`
  - Generate canonical artifact paths.
- `scripts/update_current_work.sh`
  - Update `ai-context/current-work.md` consistently.
- `scripts/refresh_project_context.sh`
  - Initialize or refresh `ai-context/project-context.md` discovery date.

## State Machine

Use this exact progression for new features:

1. `start_work`
2. `create_spec`
3. `generate_tests` (RED)
4. `research_implementation`
5. `implement` (GREEN)
6. `refactor`
7. `finish_work` (after merge/abandon)

For bug fixes:

1. `start_work`
2. bug analysis + reproduction test (RED)
3. `implement` (GREEN)
4. verification + `finish_work`

## Phase Contract

For each phase:

1. Validate entry criteria.
2. Produce or update artifact(s).
3. Update `ai-context/current-work.md`.
4. Report explicit next phase options.

### 1) Start Work

Entry:

- User requests new work, bug fix, or resume.

Actions:

- Determine work type.
- Check branch with `scripts/check_branch.sh --allow-main`.
- Ensure `ai-context/project-context.md` exists; run discovery if missing.
- Set baseline state in `ai-context/current-work.md`.

Outputs:

- Updated `ai-context/current-work.md`.
- Updated or created `ai-context/project-context.md`.

### 2) Create Spec

Entry:

- Work type is new feature.

Actions:

- Gather requirements and acceptance criteria.
- Generate spec file path with `scripts/make_artifact_name.sh spec <feature-slug> [ticket]`.
- Save spec under `ai-context/specs/`.

Outputs:

- `ai-context/specs/..._spec.md`

### 3) Generate Tests (RED)

Entry:

- Approved spec exists.

Actions:

- Verify branch safety with `scripts/check_branch.sh`.
- Create failing tests for selected layer(s).
- Create/update test plan artifact under `ai-context/tests/`.

Outputs:

- New failing tests in repo.
- `ai-context/tests/..._tests.md`

### 4) Research Implementation

Entry:

- Failing tests exist.

Actions:

- Analyze minimal code changes to satisfy tests.
- Produce implementation plan artifact.

Outputs:

- `ai-context/research/..._research.md`

### 5) Implement (GREEN)

Entry:

- Research plan and failing tests exist.

Actions:

- Verify branch safety with `scripts/check_branch.sh`.
- Implement smallest change set to make tests pass.
- Record touched files and decisions.

Outputs:

- Passing tests for scoped layer.
- `ai-context/implementation/..._implementation.md`

### 6) Refactor

Entry:

- Tests passing.

Actions:

- Improve design/readability without behavior change.
- Keep tests green.
- Record refactor notes.

Outputs:

- `ai-context/refactoring/..._refactoring.md`

### 7) Finish Work

Entry:

- Work merged or abandoned.

Actions:

- Clean up feature-specific artifacts.
- Keep shared files (`project-context.md`, workflow guide) intact.
- Reset `current-work.md` for next session.

Outputs:

- Cleaned `ai-context/` for next task.

## What To Load From References

Load only files needed for the current phase:

- `references/phases/start_work.md`
- `references/phases/create_spec.md`
- `references/phases/generate_tests.md`
- `references/phases/research_implementation.md`
- `references/phases/implement.md`
- `references/phases/refactor.md`
- `references/phases/finish_work.md`
- `references/phases/_project_discovery.md`
- `references/phases/_boundaries.md`

Do not bulk-load all reference files unless requested.
