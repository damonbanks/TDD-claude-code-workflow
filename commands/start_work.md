# Start Work Command

## Objective
Determine the type of work to be done (new feature, bug fix, or resume existing work) and guide the user to the appropriate workflow with proper phase tracking.

## Usage
```
/start_work
/start_work [optional: brief description or ticket ID]
```

## Workflow Boundaries

**Full reference: `commands/_boundaries.md`**

- **ALWAYS**: Check current branch before starting; read `current-work.md` if it exists
- **ALWAYS**: Run project discovery and cache results; save work state to `current-work.md`
- **ASK**: Confirm branch creation with user; ask for ticket ID if not auto-detected
- **ASK**: Confirm work type selection before routing to workflow
- **NEVER**: Write code on main branch — create a feature branch first
- **NEVER**: Auto-invoke next phase via Skill tool without user confirmation
- **NEVER**: Skip project discovery — every phase depends on cached project context

## Process

### Step 0: Branch Safety Check

**CRITICAL: Check current branch before starting any work.**

#### Check Current Branch
```bash
git branch --show-current
# or
git rev-parse --abbrev-ref HEAD
```

#### Branch Validation

**If on `main` or `master`:**
```
⚠️  WARNING: You're currently on the main branch.

We don't write code directly on main. Let's get you on a feature branch.
```

Use AskUserQuestion to gather information:
- **Question 1**: "Do you have a ticket ID for this work?"
  - Options:
    1. Yes, I have a ticket ID (provide it)
    2. No ticket — proceed without one

- **Question 2** (if they have a ticket): "What's your ticket ID?"
  - Free text input
  - Accept any format: `PROJ-123`, `#42`, `sc-12345`, or any identifier

- **Question 3**: "Should we create a feature branch?"
  - Options:
    1. Yes, create a branch based on ticket (Recommended)
    2. Yes, I'll specify the branch name
    3. No, I'll create it manually

**If creating a branch:**
```bash
# Recommended format: [type]/[ticket]-[brief-description]
# Types: feat, fix, refactor, chore, docs
# Examples:
git checkout -b feat/PROJ-123-user-authentication
git checkout -b fix/42-login-bug
git checkout -b feat/add-search-feature  # no ticket

# Minimal format (just ticket):
git checkout -b feat/[ticket-id]
```

**Suggested branch name:**
- Format: `[type]/[ticket]-[brief-description]` (or `[type]/[brief-description]` if no ticket)
- Type is based on work type: New Feature → `feat`, Bug Fix → `fix`, Refactor → `refactor`
- Example: `feat/PROJ-123-user-authentication`

**If user declines branch creation:**
```
Please create a feature branch before continuing:
  git checkout -b [branch-name]

Then run /start_work again.
```

#### If Already on Feature Branch
```
✅ Current branch: [branch-name]

Great! You're on a feature branch. Let's continue.
```

**Optional: Check if branch name includes ticket:**
- Auto-detect ticket from branch name using common patterns: `[A-Z]+-\d+`, `#\d+`, `sc-\d+`, or numeric IDs
- If no ticket in branch name: Ask if there's a related ticket for tracking (ticket is optional)

---

### Step 1: Identify Work Type

Ask the user what type of work they're starting using AskUserQuestion:

**Question**: "What type of work are you starting?"

**Options**:
1. **New Feature** - Starting a new feature from scratch
   - Description: "Create a new feature with full specification, tests, and implementation following the complete TDD workflow"

2. **Bug Fix** - Fixing an existing issue
   - Description: "Fix a bug with focused specification, targeted tests, and implementation. Skips some phases for faster resolution"

3. **Resume Work** - Continue working on an existing feature
   - Description: "Resume work on a feature that was started previously. Pick up from where you left off"

### Step 2: Collect Ticket ID (Optional)

After the user selects their work type (and before routing to the workflow), check for a ticket:

**First, try auto-detection:**
1. Check the current branch name for ticket patterns (`[A-Z]+-\d+`, `#\d+`, `sc-\d+`)
2. If found, confirm with the user: "I detected ticket `PROJ-123` from your branch. Is that correct?"

**If no ticket auto-detected, use AskUserQuestion:**
- Question: "Do you have a ticket ID for this work?"
- Header: "Ticket"
- Options:
  1. "Yes, I'll provide it" - User provides ticket ID (any format)
  2. "No ticket" - Proceed without one

**After user provides ticket ID:**
- Accept any format — don't enforce a specific pattern
- Store the ticket ID for use throughout the workflow
- Include ticket ID in artifact filenames, branch names, and commit messages

**If user selects "No ticket":**
```
No problem! Proceeding without a ticket.

Artifact filenames will use: YYYY-MM-DD_feature-name_type.md
You can always add a ticket reference later.
```

**Proceed without a ticket if the user doesn't have one.**

---

### Step 3: Run Project Discovery

**Before routing to any workflow, discover the project's tooling and conventions.**

Follow the protocol defined in `commands/_project_discovery.md`:

1. **Language**: Check for manifest files (`go.mod`, `package.json`, `Cargo.toml`, `pyproject.toml`, etc.)
2. **Test framework & conventions**: Find existing test files, read 2-3 to understand framework, naming, and patterns
3. **Git platform**: Read `.git/config` remote URL → determine GitHub/GitLab/Bitbucket/other
4. **Commit conventions**: Run `git log --oneline -20`, check for commitlint config
5. **Build/test/lint commands**: Check `Makefile`, `package.json` scripts, CI config, `README.md`, `AGENTS.md`
6. **Optional config override**: If `ai-context/.workflow-config.yml` exists, read it and use its values

**Cache results in `current-work.md`** under a `## Project Context` section so subsequent phases don't re-discover:

```markdown
## Project Context
- **Language(s)**: [e.g., Go 1.22, TypeScript 5.3]
- **Key frameworks**: [e.g., React 18.2, Next.js 14.1, or "none"]
- **Test framework**: [e.g., go test + testify, Jest, pytest]
- **Test command**: [e.g., make test, npm test]
- **Lint command**: [e.g., make lint, npm run lint]
- **Format command**: [e.g., make fmt, npm run format]
- **Build command**: [e.g., make build, npm run build]
- **Code generation**: [e.g., make generate, none]
- **Git platform**: [e.g., GitHub, GitLab]
- **PR/MR command**: [e.g., gh pr create, glab mr create, manual]
- **Commit convention**: [e.g., Conventional Commits: type(scope): description]
```

**If `ai-context/.workflow-config.yml` exists**, use its values to override auto-detected settings.

**Present a brief summary to the user:**
```
Project detected:
  Language:   [language(s) with versions]
  Frameworks: [key frameworks with versions]
  Tests:      [test command]
  Platform:   [git platform]
  Commits:    [convention summary]
```

---

### Step 4: Route to Appropriate Workflow

Based on the user's selection, guide them through the appropriate workflow:

---

## Workflow A: New Feature

**Purpose**: Build a new feature from scratch using Test-First Development

**Phases**:
1. **Spec Phase** (30-35% context)
   - Command: `/create_spec [feature description]`
   - Output: `ai-context/specs/[date]_[ticket]_[feature]_spec.md`
   - Action: Create comprehensive specification with all requirements

2. **Test Phase** (40-45% context)
   - Command: `/generate_tests @ai-context/specs/[file].md`
   - Output: Test files + `ai-context/tests/[date]_[ticket]_[feature]_tests.md`
   - Action: Generate failing tests first (TDD red state)
   - Verify: Run tests to confirm they fail

3. **Research Phase** (55-60% context)
   - Command: `/research_implementation @ai-context/specs/[file].md`
   - Output: `ai-context/research/[date]_[ticket]_[feature]_research.md`
   - Action: Analyze codebase and create implementation plan

4. **Implement Phase** (50-60% context)
   - Command: `/implement @ai-context/specs/[file].md --make-tests-pass`
   - Output: Code + `ai-context/implementation/[date]_[ticket]_[feature]_implementation.md`
   - Action: Write code to make tests pass (TDD green state)
   - Verify: Run tests to confirm they pass

5. **Refactor Phase** (35-40% context)
   - Command: `/refactor @ai-context/implementation/[file].md`
   - Output: Improved code + `ai-context/refactoring/[date]_[ticket]_[feature]_refactoring.md`
   - Action: Optimize, document, and cleanup while keeping tests green

**After Setup:**
```
✅ New Feature Workflow Selected

This workflow follows 5 phases:
  1. Spec - Define requirements (PLAN MODE)
  2. Test - Create failing tests (TDD RED)
  3. Research - Plan implementation
  4. Implement - Make tests pass (TDD GREEN)
  5. Refactor - Optimize & document (TDD REFACTOR)

Ticket: [TICKET-ID] (collected in Step 2)

Ready to create the specification.
```

**Use AskUserQuestion:**
- Question: "Ready to create specification?"
- Options:
  1. "Yes, start now (I'll provide requirements)" - Proceed to create_spec
  2. "No, I'll start manually later" - Stop and provide guidance

**If user selects "Yes":**
Ask for requirements, then invoke the Skill tool with:
- skill: "create_spec"
- args: "[user's requirements]"

**If user selects "No":**
```
No problem! When you're ready, run:

  /create_spec [your feature description]

I've created current-work.md to track your progress.
```

## Workflow B: Bug Fix

**Purpose**: Fix an existing bug using streamlined TDD workflow with existing commands

**Streamlined Workflow** - Reuses existing commands:
1. **Bug Analysis** (PLAN MODE) → Creates lightweight spec in `bugs/`
2. **Test** → `/generate_tests` (just reproduction test)
3. **Implement** → `/implement` (just the fix, skip research)
4. **PR** → Skip refactor unless needed

---

### Intelligent Auto-Advance for Bug Fix

**After "Bug Fix" is selected, gather bug details and create analysis:**

Ask the user for bug details (ticket was already collected in Step 2):
```
I'll help you fix this bug using a streamlined TDD workflow.

Ticket: [TICKET-ID] (collected in Step 2)

Please provide:
- Bug description or symptoms
- Steps to reproduce (if known)
- Expected vs actual behavior
```

### Step 1: Create Bug Analysis (Plan Mode)

**Enter Plan Mode** and create lightweight bug analysis:

1. **Explore codebase** to understand the issue
2. **Identify root cause** through investigation
3. **Document analysis** in plan mode
4. **Create bug analysis document**:
   - Location: `ai-context/bugs/[date]_[ticket]_[bug-name]_analysis.md`
   - Format: Lightweight spec focused on the bug

**Bug Analysis Document Template:**
```markdown
# Bug Fix: [Bug Description]

**Created**: [Date]
**Ticket**: [TICKET-ID]
**Type**: Bug Fix

## Bug Description
[What's broken]

## Symptoms
[How it manifests to users]

## Root Cause
[Why the bug occurs - identified through investigation]

## Expected Behavior
[What should happen]

## Actual Behavior
[What currently happens]

## Reproduction Steps
1. [Step 1]
2. [Step 2]
3. [Observe bug]

## Proposed Fix
[How to fix it - high level approach]

## Test Strategy
- Reproduction test (should fail before fix)
- Regression tests (if needed)
- Verification steps

## Files to Modify
- [File 1] - [Change needed]
- [File 2] - [Change needed]
```

5. **Exit Plan Mode** to get user approval

### Step 2: Phase Complete — Advance to Test Generation

After bug analysis is approved:
```
✅ Bug Analysis Complete!

Root cause identified: [brief summary]

Saved to: ai-context/bugs/[date]_[ticket]_[bug-name]_analysis.md

CONTEXT ISOLATION — run /clear before continuing.
The test writer must work from the bug analysis document alone,
not from the investigator's reasoning.

Next command (after /clear):
  /generate_tests @ai-context/bugs/[date]_[ticket]_[bug-name]_analysis.md
```

---

### Bug Fix Workflow Summary

**Streamlined 3-4 Phase Process:**
1. ✅ **Analysis** (Plan Mode) → Lightweight spec in `bugs/`
2. ✅ **Test** → `/generate_tests` (reproduction test only)
3. ✅ **Fix** → `/implement` (skip research, just fix)
4. ✅ **PR** → Optional refactor, then create PR

**Skipped Phases:**
- ❌ Research (bug fixes are focused, don't need pattern discovery)
- ❌ Refactor (optional, only if code needs cleanup)

**Benefits:**
- Faster than full feature workflow
- Still follows TDD (test before fix)
- Reuses existing commands
- Maintains traceability with bug analysis doc

## Workflow C: Resume Work

**Purpose**: Intelligently detect where you left off and auto-continue with the right command

**Smart Detection and Auto-Continue**

---

### Step 1: Read current-work.md to Detect State

**Check if `ai-context/current-work.md` exists:**

```bash
# Read current work state
cat ai-context/current-work.md
```

**If file exists, parse:**
- **Feature name** / **Ticket ID**
- **Work type** (New Feature | Bug Fix)
- **Current phase** (last completed or in-progress)
- **Artifacts** (what's been created)
- **Status** (which phases are complete)

**If file doesn't exist:**
```
📋 No current work found.

I don't see a current-work.md file. This could mean:
- You haven't started work with /start_work yet
- The work was completed and file was archived
- You're working on a different machine/context

Would you like to:
  → Start new work
  → Manually specify what to resume
```

---

### Step 2: Detect Artifacts and Current Phase

**Scope artifact discovery to the current ticket to avoid context bloat.**

First, extract the ticket ID from `current-work.md`:

```bash
# Read current-work.md to get ticket ID
cat ai-context/current-work.md
```

Then search only for artifacts matching that ticket:

```bash
# Find artifacts for this specific ticket (e.g., PROJ-123)
find ai-context -name "*[TICKET-ID]*" -type f
```

**If no ticket ID is available**, fall back to recent artifacts:

```bash
# Find artifacts modified in the last 30 days
find ai-context -name "*.md" -mtime -30 -not -name "*.template" -not -name "WORKFLOW_GUIDE.md" -not -name "README.md" -type f
```

**Do NOT use `ls -la` on every directory** — this dumps all historical artifacts into context unnecessarily.

**Determine current phase based on what exists:**

| Artifacts Found | Current Phase | Next Command |
|----------------|---------------|--------------|
| Only spec | Spec complete | `/generate_tests @specs/[file].md` |
| Spec + tests | Tests complete | `/research_implementation @specs/[file].md` |
| Spec + tests + research | Research complete | `/implement @specs/[file].md --make-tests-pass` |
| Spec + tests + research + implementation | Implementation complete | `/refactor @implementation/[file].md` |
| All artifacts | Refactor complete | Create PR |
| Only bugs/analysis | Bug analysis complete | `/generate_tests @bugs/[file].md` |
| Bug analysis + tests | Bug test complete | `/implement @bugs/[file].md --fix-bug` |

---

### Step 3: Present Smart Summary

**Show user what was detected:**

```
✅ Resuming Work Detected!

Work Type: [New Feature | Bug Fix]
Feature: [Feature name from current-work.md]
Ticket: [TICKET-ID]
Started: [Date]

Progress:
  ✅ Phase 1: Specification
  ✅ Phase 2: Tests
  ⏸️  Phase 3: Research (IN PROGRESS)
  ⏹️  Phase 4: Implementation
  ⏹️  Phase 5: Refactoring

Artifacts Found:
  ✅ ai-context/specs/[date]_[ticket]_[feature]_spec.md
  ✅ ai-context/tests/[date]_[ticket]_[feature]_tests.md
  ⏸️  ai-context/research/[date]_[ticket]_[feature]_research.md (partial)

Last Note from current-work.md:
  "[Last progress note if available]"

─────────────────────────────────────────────────
Detected Next Step: Complete Research Phase
─────────────────────────────────────────────────

You were in the middle of researching implementation patterns.

Command:
  /research_implementation @ai-context/specs/[date]_[ticket]_[feature]_spec.md

Would you like me to continue where you left off?
  → Yes - Resume research now (Recommended)
  → No - I'll review first and run manually
  → Different phase - I want to work on a different phase
```

**Use AskUserQuestion:**
- Question: "Resume from detected phase?"
- Options:
  1. "Yes, continue [phase name] now (Recommended)"
  2. "No, I'll review and run manually"
  3. "Different phase - Let me choose"

---

### Step 4: Present Next Command

**If user selects "Yes":**

Present the next command for the user to run (do NOT invoke Skill tools — the user must run the command after `/clear`):

```
To continue, run /clear first, then:

  /[next-command] @ai-context/[type]/[file].md
```

**Phase-to-Command Mapping:**
- Spec incomplete → `/create_spec [continue or requirements]`
- Tests incomplete → `/generate_tests @ai-context/specs/[file].md`
- Research incomplete → `/research_implementation @ai-context/specs/[file].md`
- Implementation incomplete → `/implement @ai-context/specs/[file].md --make-tests-pass`
- Refactor incomplete → `/refactor @ai-context/implementation/[file].md`

**If user selects "No":**
```
No problem! Here's where you are:

Current phase: [Phase name]
Next command: /[command] @ai-context/[type]/[file].md

When you're ready, run that command.
I'll be here to help!
```

**If user selects "Different phase":**

Ask which phase they want to work on:
```
Which phase would you like to work on?
  1. Spec Phase
  2. Test Phase
  3. Research Phase
  4. Implementation Phase
  5. Refactoring Phase
```

Then provide the appropriate command for that phase.

---

### Step 5: Handle Edge Cases

**If multiple features detected:**
```
📋 Multiple work items found:

1. [Feature A] (Ticket: PROJ-123) - In Research Phase
2. [Feature B] (Ticket: #42) - In Implementation Phase

Which one would you like to resume?
```

**If current-work.md exists but artifacts missing:**
```
⚠️  Mismatch detected!

current-work.md says you're in [Phase X], but I can't find the artifacts.

This could mean:
- Files were moved or deleted
- Working from different directory
- current-work.md is stale

Would you like to:
  → Start fresh on this feature
  → Manually specify what to load
  → Update current-work.md
```

**If work is complete (all artifacts exist):**
```
🎉 Work appears complete!

All artifacts exist:
  ✅ Spec
  ✅ Tests
  ✅ Research
  ✅ Implementation
  ✅ Refactoring

This feature looks done! Options:
  → Create PR
  → Review/verify one more time
  → Start new work
```

---

### Resume Work Summary

**Smart Detection:**
- ✅ Automatically reads current-work.md
- ✅ Scans for artifacts to confirm state
- ✅ Determines next phase intelligently
- ✅ Shows clear progress summary

**Resume Guidance:**
- ✅ Suggests exact next command (after `/clear`)
- ✅ References correct artifact files
- ✅ Handles edge cases gracefully

**No Manual Tracking Needed:**
- Just run `/start_work` → "Resume Work"
- AI figures out where you are
- One click to continue

---

## Context Isolation Protocol

**TDD integrity requires strict context isolation between phases.** Each phase must work from artifact files alone, not from the previous phase's reasoning in the context window.

**Why isolation matters:**
- The spec author's reasoning must not bleed into the test writer
- The test designer's analysis must not bleed into the implementer
- Each role should bring fresh perspective to its phase

**Between ALL phases** (including Bug Fix):
1. Complete the current phase
2. Run `/clear` to reset context
3. Run the next phase command, which reads artifact files from disk

**Phases communicate only through artifact files in `ai-context/`.**

**Tracking Progress**:

Create a work tracking file to maintain state:
```
ai-context/current-work.md
```

**Format**:
```markdown
# Current Work

**Type**: New Feature | Bug Fix | Resume
**Feature**: [name]
**Ticket**: [ID or "none"]
**Started**: YYYY-MM-DD
**Current Phase**: Spec | Test | Research | Implement | Refactor

## Project Context
- **Language(s)**: [discovered languages with versions, e.g., Go 1.22, TypeScript 5.3]
- **Key frameworks**: [discovered frameworks with versions, e.g., React 18.2, or "none"]
- **Test framework**: [discovered framework]
- **Test command**: [discovered command]
- **Lint command**: [discovered command or "none"]
- **Format command**: [discovered command or "none"]
- **Build command**: [discovered command or "none"]
- **Code generation**: [discovered command or "none"]
- **Git platform**: [GitHub | GitLab | Bitbucket | other]
- **PR/MR command**: [gh pr create | glab mr create | manual]
- **Commit convention**: [discovered pattern]

## Artifacts
- Spec: ai-context/specs/[date]_[ticket]_[feature]_spec.md
- Tests: ai-context/tests/[date]_[ticket]_[feature]_tests.md
- Research: ai-context/research/[date]_[ticket]_[feature]_research.md
- Implementation: ai-context/implementation/[date]_[ticket]_[feature]_implementation.md
- Refactoring: ai-context/refactoring/[date]_[ticket]_[feature]_refactoring.md

## Status
- [x] Spec Phase
- [x] Test Phase
- [ ] Research Phase (in progress)
- [ ] Implement Phase
- [ ] Refactor Phase

## Notes
[Any important context or decisions]
```

---

## Implementation Guide

### When User Runs `/start_work`

1. **Use AskUserQuestion** to present the three work type options
2. **Based on selection**, provide the appropriate workflow guidance
3. **For New Feature**: Prompt for requirements and move to `/create_spec`
4. **For Bug Fix**: Gather bug details and create reproduction test
5. **For Resume Work**: Use AskUserQuestion again to identify phase, then load artifacts

### Example Interaction

```
User: /start_work

AI: I'll help you get started. First, let me understand what type of work you're doing.

[Presents AskUserQuestion with 3 options]

User: [Selects "New Feature"]

AI: Great! Let's start a new feature using the Test-First Development workflow.

This will involve 5 phases:
1. Spec - Define requirements and acceptance criteria
2. Test - Write failing tests first (TDD red state)
3. Research - Plan implementation approach
4. Implement - Make tests pass (TDD green state)
5. Refactor - Optimize and improve code quality

Please provide:
- Brief description of the feature
- Ticket ID (if you have one, e.g., PROJ-123, #42, or any format)

I'll then create the specification to get us started.
```

---

## Benefits of This Approach

### 1. Clear Entry Point
- Users always know where to start
- Workflow is discoverable and guided

### 2. Appropriate Workflow for Work Type
- Full TDD workflow for new features
- Streamlined workflow for bug fixes
- Smart resumption for in-progress work

### 3. Progress Tracking
- `current-work.md` tracks state
- Easy to pick up where you left off
- Prevents confusion about which phase you're in

### 4. Flexibility
- Can switch between work types
- Can adjust workflow based on needs
- Maintains all benefits of structured approach

### 5. Reduced Cognitive Load
- Don't need to remember all commands
- Guided through appropriate steps
- Clear indication of what's next

---

## Integration with Existing Commands

The existing commands remain unchanged:
- `/create_spec` - Used in Phase 1 of New Feature workflow
- `/generate_tests` - Used in Phase 2 of New Feature workflow
- `/research_implementation` - Used in Phase 3 of New Feature workflow
- `/implement` - Used in Phase 4 of New Feature workflow and Bug Fix workflow
- `/refactor` - Used in Phase 5 of New Feature workflow

`/start_work` acts as the **orchestrator** that routes to the appropriate command based on work type.

---

## File Structure After Using This Command

```
ai-context/
├── current-work.md                    # NEW: Tracks current work state
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
├── bugs/                              # NEW: For bug fix tracking
│   └── [date]_[ticket]_bug-name_analysis.md
└── WORKFLOW_GUIDE.md
```

---

## Tips for Different Work Types

### New Feature
- Don't skip phases
- Take time in spec phase to get requirements right
- Run `/clear` between each phase
- Commit at each phase

### Bug Fix
- Focus on reproduction first
- Keep scope narrow
- Consider if bug reveals larger architectural issues
- If so, may need to escalate to full feature workflow

### Resume Work
- Review previous artifacts before continuing
- Update `current-work.md` with latest status
- Clear any stale context before loading new artifacts
- Verify tests still pass before continuing implementation

---

## Summary

**Start every work session with:**
```
/start_work
```

**The command will:**
1. Ask what type of work you're doing
2. Guide you to the appropriate workflow
3. Help you load relevant context if resuming
4. Track your progress in `current-work.md`

**This creates a consistent entry point for all development work while maintaining flexibility for different work types.**
