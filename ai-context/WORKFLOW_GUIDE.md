# AI-Assisted Development Workflow Guide

**Workflow Type**: Test-First TDD Approach

## Quick Start

**Every work session begins with:**
```
/start_work
```

This single command will:
1. Ask what type of work you're doing
2. Guide you to the appropriate workflow
3. **Tell you which command to run next** (after `/clear`)
4. Track your progress
5. Help you resume if you were interrupted

### Context Isolation

Each phase runs in a **fresh context** — run `/clear` between phases. After completing each phase, the workflow will:
- Show what was accomplished
- Remind you to run `/clear`
- Tell you the next command to run

Phases communicate **only through artifact files** in `ai-context/`.

---

## Work Types

### New Feature
**When to use:** Building something new from scratch

**Workflow:**
```
/start_work -> Select "New Feature"
  |
Phase 1: /create_spec [description]              <- PLAN MODE (requires approval)
  |  (run /clear)
Phase 2: /generate_tests @specs/[file].md
  |  (run /clear)
Phase 3: /research_implementation @specs/[file].md
  |  (run /clear)
Phase 4: /implement @specs/[file].md --make-tests-pass
  |  (run /clear)
Phase 5: /refactor @implementation/[file].md      <- PLAN MODE for assessment
  |
Create PR
  |
/finish_work                                       <- Cleanup after merge
```

**Plan Mode Phases:**
- **Phase 1 (Spec)**: Explores codebase, gathers requirements, gets approval on specification
- **Phase 3 (Research)**: Optionally uses plan mode to explore and plan implementation
- **Phase 5 (Refactor)**: Uses plan mode to assess system holistically, create refactoring strategy, get approval before execution

**Time investment:** Full TDD cycle, highest quality
**Context management:** Run `/clear` between every phase

---

### Bug Fix
**When to use:** Fixing an existing issue

**Workflow:**
```
/start_work -> Select "Bug Fix"
  |
1. Bug Analysis        <- PLAN MODE (understand, root cause, get approval)
  |  (run /clear)
2. Create Reproduction Test (should fail)
  |  (run /clear)
3. Implement Fix (make test pass)
  |
4. Verification (check for regressions)
  |
Create PR
```

**Plan Mode Phase:**
- **Phase 1 (Bug Analysis)**: Explores codebase to understand bug, identifies root cause, gets approval on approach before fixing

**Time investment:** Streamlined, focused on the fix
**Context management:** Run `/clear` between phases

---

### Resume Work
**When to use:** Continuing interrupted work

**Workflow:**
```
/start_work -> Select "Resume Work"
  |
AI identifies where you left off
  |
AI loads relevant artifacts
  |
Continue from current phase
```

**Time investment:** Minimal overhead to resume
**Context management:** Loads only what's needed

---

## Plan Mode vs Implementation Mode

This workflow uses two distinct modes:

### Plan Mode (Exploration & Planning)
**Used in:**
- Phase 1: Spec (New Feature)
- Phase 1: Bug Analysis (Bug Fix)
- Phase 3: Research (New Feature) - *optional*
- Phase 5: Refactor - System Assessment (New Feature)

**Characteristics:**
- **No code changes** - exploration only
- **User approval required** - must approve plan before proceeding
- **Safe to explore** - can read, search, analyze without risk
- **Encourages thorough planning** - understand before acting

**Why use Plan Mode:**
- Specification and bug analysis are about understanding, not implementing
- User should approve the approach before committing to tests/code
- Prevents costly mistakes from premature implementation
- Allows discussion and course correction early

**Tools available in Plan Mode:**
- Read, Grep, Glob - explore codebase
- WebFetch - research documentation
- AskUserQuestion - clarify requirements
- Write (for plan/spec files only) - document findings
- AskUserQuestion - request approval to proceed

### Implementation Mode (Execution)
**Used in:**
- Phase 2: Test (New Feature)
- Phase 4: Implement (New Feature)
- Phase 5: Refactor - Execution (New Feature) - *after plan approval*
- Phases 2-4 (Bug Fix: Test, Fix, Verification)

**Characteristics:**
- **Makes changes** - writes code, creates files, runs commands
- **Executes the plan** - follows approved specification/analysis
- **Results in commits** - produces tangible changes
- **May ask questions** - but generally follows plan

### Mode Summary

| Phase | Mode | Why |
|-------|------|-----|
| **Spec (New Feature)** | Plan Mode | Understand requirements and get approval before writing tests |
| **Bug Analysis** | Plan Mode | Investigate root cause and get approval before changing code |
| **Research (Optional)** | Plan Mode | Explore implementation patterns before coding |
| **Test** | Implementation | Execute approved spec |
| **Implement** | Implementation | Execute approved plan |
| **Refactor** | Plan Mode then Implementation | Assess system holistically, then execute improvements |

---

## Workflow Phases (New Feature)

### Phase 1: Spec (30-35% context) [PLAN MODE]
**Command**: `/create_spec [feature requirements]`
**Purpose**: Generate comprehensive specification with acceptance criteria
**Output**: `ai-context/specs/[date]_[ticket]_[feature]_spec.md`
**Mode**: Plan Mode (requires user approval before proceeding)

**What happens:**
1. **Enters Plan Mode** - Exploration without changes
2. AI explores codebase to understand existing patterns
3. AI uses plain text requirements as input
4. AI asks clarifying questions about requirements
5. Generates detailed specification with testable criteria
6. Documents API contracts, data models, and dependencies
7. Writes spec to ai-context directory
8. **Exits Plan Mode** - Requests user approval

---

### Phase 2: Test (40-45% context)
**Command**: `/generate_tests @ai-context/specs/[date]_[ticket]_[feature]_spec.md`
**Purpose**: Create failing tests FIRST (true TDD red state)
**Output**: Test files + `ai-context/tests/[date]_[ticket]_[feature]_tests.md`

**What happens:**
1. AI reads the specification
2. Creates comprehensive test suite covering all requirements
3. Tests are designed to FAIL (code doesn't exist yet)
4. Commits tests to repository
5. Documents test plan

**Test locations:**
- Discover from existing test patterns in the repository
- Look for `*_test.*`, `*.test.*`, or `*.spec.*` files near similar features

---

### Phase 3: Research (55-60% context)
**Command**: `/research_implementation @ai-context/specs/[date]_[ticket]_[feature]_spec.md @tests/`
**Purpose**: Analyze codebase to determine what needs changing
**Output**: `ai-context/research/[date]_[ticket]_[feature]_research.md`

**What happens:**
1. AI explores existing codebase patterns
2. Identifies files to create/modify
3. Determines implementation order
4. Documents dependencies and patterns
5. Creates step-by-step implementation plan

**Research includes:**
- Files to create/modify
- Implementation order (discovered from repository architecture)
- Code patterns from similar features
- Dependencies and integration points

---

### Phase 4: Implement (50-60% context)
**Command**: `/implement @ai-context/specs/[date]_[ticket]_[feature]_spec.md --make-tests-pass`
**Purpose**: Write code to make tests pass (TDD green state)
**Output**: Implementation + `ai-context/implementation/[date]_[ticket]_[feature]_implementation.md`

**What happens:**
1. AI follows research plan step-by-step
2. Implements database migrations, queries, handlers, components
3. Runs tests continuously (moving from RED to GREEN)
4. Fixes failing tests iteratively
5. Documents implementation and challenges

**Implementation order:**
Follow the order defined in the research document. Typical pattern:
1. Foundation layer (database, schemas, models)
2. Generated code (API definitions, code generation)
3. Business logic (services, handlers, controllers)
4. Integration (wiring, composition, routing)
5. Presentation (UI components, hooks, pages)

---

### Phase 5: Refactor (35-40% context) [PLAN MODE for assessment]
**Command**: `/refactor @ai-context/implementation/[feature].md`
**Purpose**: Optimize, document, cleanup while keeping tests green
**Output**: Improved code + `ai-context/refactoring/[date]_[ticket]_[feature]_refactoring.md`
**Mode**: Plan Mode for system assessment, then Implementation Mode for execution

**What happens:**
1. **Enters Plan Mode** - System assessment phase
2. AI analyzes implementation holistically across all files
3. Identifies cross-cutting concerns and systemic improvements
4. Creates coherent refactoring strategy with logical groupings
5. **Exits Plan Mode** - Requests approval on strategy
6. Executes refactorings in planned order (implementation mode)
7. Runs tests after each logical group (tests stay GREEN)
8. Documents refactoring decisions

**Refactoring checklist:**
- Code quality (duplication, naming, simplification)
- Documentation (comments, README updates)
- Error handling (consistent, wrapped)
- Performance (queries, allocations, rendering)
- Security (validation, injection prevention)
- Testing (coverage, clarity, independence)
- Repository conventions (formatting, linting)

---

## Context Isolation

### Why Isolation Matters
TDD's power comes from **role separation**. When all phases share a context window, the LLM's reasoning bleeds across phase boundaries — the spec author's thinking influences the test writer, the test designer's analysis shapes the implementer. This defeats TDD's core discipline.

### The `/clear` Protocol
Every phase transition requires running `/clear` to reset the context window:

```
Phase 1: /create_spec → artifacts saved → /clear
Phase 2: /generate_tests → artifacts saved → /clear
Phase 3: /research_implementation → artifacts saved → /clear
Phase 4: /implement → artifacts saved → /clear
Phase 5: /refactor → artifacts saved → done
```

### How Phases Communicate
Phases communicate **only through artifact files** on disk:

| Phase | Reads From | Writes To |
|-------|-----------|-----------|
| Spec | User requirements | `ai-context/specs/` |
| Test | Spec artifact | Test files + `ai-context/tests/` |
| Research | Spec + test artifacts | `ai-context/research/` |
| Implement | Research + spec artifacts | Code + `ai-context/implementation/` |
| Refactor | Implementation artifact | Improved code + `ai-context/refactoring/` |

### Context Budgets by Phase
- Spec: 30-35% (max 40%)
- Test: 40-45% (max 50%)
- Research: 55-60% (max 65%)
- Implement: 50-60% (max 65%)
- Refactor: 35-40% (max 45%)

---

## Workflow Boundaries

The workflow uses a three-tier boundary system (defined in `commands/_boundaries.md`) to clarify what AI agents may do autonomously, what requires approval, and what is prohibited.

### ALWAYS (No Approval Needed)
- Run tests before commits; run linters after changes
- Check branch (verify not on main); read `current-work.md`
- Save artifacts to `ai-context/`; follow discovered patterns
- Use the project's actual commands; commit at phase boundaries

### ASK (Requires User Approval)
- Approve specifications and refactoring strategies
- Add dependencies; modify schemas or API contracts
- Deviate from spec; skip phases; modify existing tests during implementation
- Mark requirements N/A

### NEVER (Hard Stop)
- Commit secrets; write code on main
- Auto-invoke next phase via Skill tool (context isolation requires `/clear`)
- Skip test phase; modify tests to make them pass
- Exceed context budget; push/force-push without request
- Delete files outside `ai-context/` without confirmation; hardcode paths

Each command file has a phase-specific `## Workflow Boundaries` section. See `commands/_boundaries.md` for the full reference.

---

## Examples

### Starting a New Feature

```bash
# Step 1: Start work
> /start_work

AI: What type of work are you starting?
  1. New Feature
  2. Bug Fix
  3. Resume Work

> New Feature

AI: Great! Please provide:
    - Feature description
    - Ticket ID (if you have one, any format — e.g., PROJ-123, #42)

> Add user profile management. Ticket: PROJ-5678

AI: [Creates ai-context/current-work.md]
    Perfect! Let's begin with /create_spec

# Step 2: Create specification
> /create_spec Add user profile management with ability to view and edit profile

AI: [Enters Plan Mode]
    [Asks clarifying questions]
    [Generates specification]
    [Saves to ai-context/specs/2026-02-09_PROJ-5678_user-profile_spec.md]
    [Exits Plan Mode - requests approval]
    [Updates current-work.md: Spec Phase complete]

# Step 3: Clear context and generate tests
> /generate_tests @ai-context/specs/2026-02-09_PROJ-5678_user-profile_spec.md

AI: [Creates failing tests]
    [Saves to ai-context/tests/2026-02-09_PROJ-5678_user-profile_tests.md]
    [Updates current-work.md: Test Phase complete]

# Continue through remaining phases...
```

### Fixing a Bug

```bash
# Step 1: Start work
> /start_work

AI: What type of work are you starting?

> Bug Fix

AI: Please provide:
    - Bug description
    - Ticket ID (if you have one, e.g., PROJ-123, #42)
    - Steps to reproduce (if known)

> Login fails with special characters in password. Ticket: BUG-456

AI: [Creates ai-context/bugs/2026-02-09_BUG-456_login-special-chars_analysis.md]
    [Creates current-work.md for bug fix]

    Let me help you fix this bug. First, let's reproduce it...

# AI guides you through:
# 1. Understanding the bug
# 2. Creating a reproduction test
# 3. Implementing the fix
# 4. Verifying the fix works
```

### Resuming Work

```bash
# Step 1: Start work
> /start_work

AI: What type of work are you starting?

> Resume Work

AI: Which phase were you working on?
  1. Spec Phase
  2. Test Phase
  3. Research Phase (in progress) <- detected
  4. Implement Phase
  5. Refactor Phase

> Research Phase

AI: [Reads ai-context/current-work.md]
    [Loads ai-context/specs/2026-02-09_PROJ-5678_user-profile_spec.md]
    [Loads ai-context/tests/2026-02-09_PROJ-5678_user-profile_tests.md]
    [Loads ai-context/research/2026-02-09_PROJ-5678_user-profile_research.md]

    I can see you were researching the user profile implementation.
    You've identified 3 files to modify and were planning the
    database migration. Should we continue with the research phase
    or move to implementation?
```

---

## Directory Structure

```
ai-context/
├── current-work.md                    # Tracks current work state and progress
├── current-work.md.template           # Template for new work
├── specs/
│   └── YYYY-MM-DD_TICKET-ID_feature-name_spec.md
├── tests/
│   └── YYYY-MM-DD_TICKET-ID_feature-name_tests.md
├── research/
│   └── YYYY-MM-DD_TICKET-ID_feature-name_research.md
├── implementation/
│   └── YYYY-MM-DD_TICKET-ID_feature-name_implementation.md
├── refactoring/
│   └── YYYY-MM-DD_TICKET-ID_feature-name_refactoring.md
├── bugs/
│   └── YYYY-MM-DD_TICKET-ID_bug-name_analysis.md
└── WORKFLOW_GUIDE.md                  # This file

.claude/
└── commands/
    ├── start_work.md
    ├── create_spec.md
    ├── generate_tests.md
    ├── research_implementation.md
    ├── implement.md
    ├── refactor.md
    └── finish_work.md
```

**File Naming Convention:**
`YYYY-MM-DD_TICKET-ID_feature-name_type.md` (with ticket)
`YYYY-MM-DD_feature-name_type.md` (without ticket)

- `YYYY-MM-DD` = date work started
- `TICKET-ID` = ticket identifier, any format (optional — omit if no ticket)
- `feature-name` = kebab-case feature or bug description
- `type` = one of: `spec`, `tests`, `research`, `implementation`, `refactoring`, `analysis` (bugs)

Examples:
- `2025-01-15_PROJ-123_user-authentication_spec.md`
- `2025-01-15_user-authentication_spec.md` (no ticket)

### Artifact Lifecycle

Artifacts live on **feature branches** and are cleaned up after merge:

1. **Created** during workflow phases on the feature branch
2. **Committed** alongside code in the feature branch
3. **Visible** in PRs for review context
4. **Cleaned up** after merge via `/finish_work`

**What's in .gitignore:**
- `ai-context/current-work.md` — session-specific, not shared

**What's protected (never deleted by `/finish_work`):**
- `ai-context/WORKFLOW_GUIDE.md`
- `ai-context/README.md`
- `ai-context/current-work.md.template`
- `ai-context/bugs/.gitkeep`

---

## Repository Integration

### Branching Strategy

**CRITICAL: Never write code on main branch.**

#### Branch Safety Checks
All commands that write code include automatic branch checks:
- `/start_work` - Checks branch and helps create feature branches
- `/generate_tests` - Verifies not on main before creating tests
- `/implement` - Verifies not on main before writing code
- `/refactor` - Warns if on main, blocks execution phase

#### Branch Naming Convention
```
Format: [type]/[ticket]-[brief-description]
        [type]/[brief-description]  (if no ticket)

Types: feat, fix, refactor, chore, docs
Examples:
- feat/PROJ-123-user-authentication
- fix/42-login-bug
- feat/add-search-feature  (no ticket)
- refactor/PROJ-5678-extract-auth-middleware
```

#### Creating a Feature Branch
```bash
# From main
git checkout main
git pull
git checkout -b [type]/[ticket]-[description]

# Examples
git checkout -b feat/PROJ-123-add-user-profiles
git checkout -b fix/#42-login-bug
```

#### Ticket Tracking
- **A ticket is recommended but optional**: Any format accepted (e.g., `PROJ-123`, `#42`, `sc-12345`)
- `/start_work` auto-detects ticket from branch name, or asks the user
- If no ticket: workflow proceeds without one — artifact filenames omit the ticket portion
- Ticket ID (when present) is used in: artifact filenames, branch names, and commit messages

#### If You're On Main
When `/start_work` detects you're on main:
1. Asks for your ticket ID
2. Suggests creating a feature branch
3. Provides command to create branch
4. Waits for you to switch branches

**Never proceed with code changes on main.**

### Commit Message Format

**Discover the project's commit convention** by running `git log --oneline -20` and checking for commitlint config.

Follow whatever pattern the project already uses. If no clear pattern exists, default to Conventional Commits:
```
type(scope): description

type: fix, feat, chore, refactor, test, docs
scope: project-specific (e.g., core, api, db, web, ci)

Examples:
- docs(core): add specification for entity management
- test(core): PROJ-123 add failing tests for entity management
- feat(core): #42 implement entity management
- refactor(core): optimize and document entity management
```

### Testing Commands

Discover test and build commands from the repository (check `Makefile`, `package.json`, `README.md`, `AGENTS.md`, or CI config):

```bash
# Common patterns - use the actual commands for your repository
make test                       # If Makefile exists
go test ./...                   # Go projects
npm test / pnpm test            # Node projects
make generate                   # Code generation (if applicable)
```

### CI/CD Integration
Check your project's CI config (`.github/workflows/`, `.gitlab-ci.yml`, etc.) for:
- Commit format enforcement
- Automated test runs on PRs
- Lint/format checks
- Other project-specific checks

---

## Commands Quick Reference

| Command | Phase | Purpose | Context | Output |
|---------|-------|---------|---------|--------|
| `/start_work` | 0 | Determine work type and route to workflow | 10-15% | Guidance + `current-work.md` |
| `/create_spec` | 1 | Generate specification | 30-35% | `specs/[date]_[ticket]_[feature]_spec.md` |
| `/generate_tests` | 2 | Create failing tests | 40-45% | Test files + `tests/[date]_[ticket]_[feature]_tests.md` |
| `/research_implementation` | 3 | Analyze implementation needs | 55-60% | `research/[date]_[ticket]_[feature]_research.md` |
| `/implement` | 4 | Write code to pass tests | 50-60% | Code + `implementation/[date]_[ticket]_[feature]_implementation.md` |
| `/refactor` | 5 | Optimize and cleanup | 35-40% | Improved code + `refactoring/[date]_[ticket]_[feature]_refactoring.md` |
| `/finish_work` | - | Clean up after PR merge | 5% | Removes artifacts for completed ticket |

---

## Tips for Success

### Do This
- Always start with `/start_work`
- Run `/clear` between each phase
- Commit at each phase
- Update `current-work.md` as you progress
- Run tests frequently

### Avoid This
- Jumping directly to implementation without spec
- Skipping the test phase
- Chaining phases in the same context (breaks TDD isolation)
- Carrying too much context
- Modifying tests during implementation
- Forgetting to track progress in `current-work.md`
- Writing code on main branch
- Skipping the refactor phase

---

## Common Questions

**Q: Do I need to use all 5 phases for every feature?**
A: For new features, yes. For bug fixes, use the streamlined 4-phase bug workflow.

**Q: What if I need to step away in the middle of a phase?**
A: Update `current-work.md` with your progress notes, then use `/start_work` -> "Resume Work" when you return.

**Q: Can I switch between multiple features?**
A: Yes! Each feature has its own artifacts. Use `/start_work` to switch contexts cleanly.

**Q: What if the bug is actually a new feature?**
A: Start with `/start_work` -> "Bug Fix" to investigate. If it reveals a larger architectural need, you can escalate to the full feature workflow.

**Q: How do I know which phase I'm in?**
A: Check `ai-context/current-work.md` - it tracks your current phase and progress.

---

## Workflow Customization

### Adjusting Context Budgets
If you find phases using too much context:
- Break features into smaller pieces
- Reference artifacts more, load less
- Use focused prompts

### Adding Custom Phases
To add custom phases:
1. Create command file in `.claude/commands/[phase].md`
2. Follow existing command structure
3. Document context budget and outputs

### Adapting to Your Project
This workflow auto-detects your project's language, test framework, git platform, and conventions. If auto-detection doesn't work for your setup:
- Copy `ai-context/.workflow-config.yml.template` to `ai-context/.workflow-config.yml` and configure overrides
- The TDD phase sequence (Spec -> Test -> Research -> Implement -> Refactor) stays the same regardless of tech stack

---

## Getting Help

- **In Claude Code:** Type `/help`
- **Workflow questions:** Read this file
- **Command details:** Check `.claude/commands/[command].md`
- **Report issues:** https://github.com/anthropics/claude-code/issues

---

## Quick Start Checklist

Ready to use the workflow? Verify:

- Commands exist in `.claude/commands/`:
  - `start_work.md`
  - `create_spec.md`
  - `generate_tests.md`
  - `research_implementation.md`
  - `implement.md`
  - `refactor.md`

- Directory structure exists:
  - `ai-context/specs/`
  - `ai-context/tests/`
  - `ai-context/research/`
  - `ai-context/implementation/`
  - `ai-context/refactoring/`
  - `ai-context/bugs/`

- You understand:
  - The 3 work types (new feature, bug fix, resume)
  - The 5 phases for new features
  - Context management strategy
  - File naming conventions
  - When to clear context

- You're ready to:
  - Start with `/start_work` (always begin here)
  - Select appropriate work type
  - Follow the guided workflow
  - Clear context between phases
  - Commit at each phase

---

**Remember: Every session starts with `/start_work`**
