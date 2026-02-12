# Implement Command

## Objective
Write code to make the failing tests pass, following the research plan and TDD principles (Red → Green).

## Project Context

**Before starting, read `ai-context/current-work.md` for cached project discovery results.**

The `## Project Context` section contains the test command, lint command, build command, and other tooling discovered by `/start_work`. Use these values for:
- Running tests (use the cached test command, not a guess)
- Running linters and formatters after changes
- Running code generation commands
- Formatting commit messages

**If `current-work.md` doesn't exist or has no Project Context section**, run the discovery protocol from `commands/_project_discovery.md` and cache the results.

## Context Budget
- Start: ~30-35% (research + test references)
- End: ~50-60% (research + tests + implementation)
- Never exceed 65%

## Prerequisites
- Completed research: `ai-context/research/[date]_[ticket]_[feature]_research.md`
- Failing tests in codebase
- Clear understanding of implementation order

## Process

**CRITICAL: The below phases may or may not be needed and are simply suggestions of execution. Follow the implementation plan**

### Phase 0: Branch Safety Check

**CRITICAL: Verify we're not on main branch before writing implementation code.**

```bash
git branch --show-current
```

**If on `main` or `master`:**
```
⚠️  STOP: You're on the main branch.

We don't write implementation code on main.

Please create or switch to a feature branch:
  git checkout -b feat/[ticket-id]-[feature-name]

Then run this command again.
```

**If on a feature branch:**
```
✅ Current branch: [branch-name]
Proceeding with implementation...
```

---

### Phase 1: Load Implementation Plan
1. Reference research: `@ai-context/research/[date]_[ticket]_[feature]_research.md`
2. Reference spec: `@ai-context/specs/[date]_[ticket]_[feature]_spec.md`
3. Review test files to understand what needs to pass
4. Verify tests are currently failing: Run the project's test command (discovered from Makefile, package.json, CI config, or README)

### Phase 2: Follow Implementation Order
Execute the implementation steps from research document IN ORDER.

**CRITICAL: Follow the patterns discovered in the research phase, not hardcoded examples.**

The research document (`ai-context/research/[date]_[ticket]_[feature]_research.md`) contains:
- The exact files to create and modify
- The patterns discovered from similar implementations in this repo
- The implementation order based on actual dependency chains
- The code generation commands specific to this repository

For each step in the research plan:
1. Read the referenced pattern files to understand the convention
2. Create or modify files following those discovered patterns
3. Run any code generation commands identified in the research
4. Run tests to verify progress

**Do not assume folder structures, naming conventions, or architectural patterns. Always follow what was discovered in the research phase.**

### Phase 3: Run Tests Continuously
After each implementation step, run tests to check progress.

**Discover test commands from the repository** (check `Makefile`, `package.json`, `README.md`, or CI config):

```bash
# Run the project's test command (discovered from Makefile, package.json, CI config, README)
# Example patterns: make test, go test ./..., npm test, cargo test, pytest, etc.
[project test command]
```

**Goal**: Move from RED (failing) → GREEN (passing)

### Phase 4: Fix Failing Tests
If tests still fail:
1. Read test output carefully
2. Identify what the test expects vs. what the code does
3. Adjust implementation (NOT tests)
4. Re-run tests
5. Repeat until GREEN

### Phase 5: Document Implementation
Create implementation log in `ai-context/implementation/[date]_[ticket]_[feature]_implementation.md`:

```markdown
# Implementation: [Feature Name]

**Created**: [Date]
**Research**: @ai-context/research/[date]_[ticket]_[feature]_research.md
**Tests**: @ai-context/tests/[date]_[ticket]_[feature]_tests.md

## Files Created
1. `path/to/file.go` - Description
2. `path/to/component.tsx` - Description

## Files Modified
1. `[path/to/existing/file]` - Changes made
2. `[path/to/another/file]` - Changes made

## Code Generation Commands Run
```bash
[list any code generation commands that were run]
```

## Test Results

### Before Implementation
```
[paste failing test output]
```

### After Implementation
```
[paste passing test output]
```

## Challenges & Solutions

### Challenge 1: [Description]
**Solution**: [How it was resolved]

### Challenge 2: [Description]
**Solution**: [How it was resolved]

## Implementation Notes

### Design Decisions
- Decision 1: [Why this approach]
- Decision 2: [Trade-offs considered]

### Code Patterns Used
- Handler factory pattern for dependency injection
- Service composition in service.go
- [Other patterns]

## Verification

### Tests Passing
- ✅ All unit tests pass
- ✅ Integration tests pass (if applicable)
- ✅ No regressions in existing tests

### Manual Testing
- ✅ Feature works as specified
- ✅ Error cases handled correctly
- ✅ Edge cases handled correctly

## Intelligent Auto-Advance to Next Phase

**After implementation is complete and all tests pass, suggest the next step.**

Present this to the user:

```
✅ Implementation Complete!

Implementation saved to:
  ai-context/implementation/[date]_[ticket]_[feature]_implementation.md

Status:
  ✅ All tests passing (GREEN state)
  ✅ Feature implemented
  ✅ Code committed

─────────────────────────────────────────────────
Next Step: Refactor (Phase 5)
─────────────────────────────────────────────────

The next phase is to optimize, document, and clean up the implementation
while keeping tests green. This is the TDD REFACTOR phase.

The refactor phase will:
  1. Enter plan mode to assess system holistically
  2. Identify cross-cutting improvements
  3. Create refactoring strategy
  4. Get your approval
  5. Execute refactorings in logical groups

Command:
  /refactor @ai-context/implementation/[date]_[ticket]_[feature]_implementation.md

Would you like me to proceed to refactoring?
  → Yes - I'll run the command automatically
  → No - I'll stop here, you can run it manually later
  → Skip - Feature is done, create PR now
```

**Use AskUserQuestion:**
- Question: "Proceed to refactoring phase?"
- Options:
  1. "Yes, refactor now (Recommended)" - Auto-run `/refactor`
  2. "No, I'll run it manually later" - Stop and provide command
  3. "Skip, feature is complete" - Suggest creating PR

**If user selects "Yes":**
```
Great! Starting refactoring phase...

Running: /refactor @ai-context/implementation/[date]_[ticket]_[feature]_implementation.md
```
Then invoke the Skill tool with:
- skill: "refactor"
- args: "@ai-context/implementation/[date]_[ticket]_[feature]_implementation.md"

**If user selects "No":**
```
No problem! When you're ready, run:

  /refactor @ai-context/implementation/[date]_[ticket]_[feature]_implementation.md

I'll be here when you need me.
```

**If user selects "Skip":**
```
✅ Feature complete! Ready to create a pull request.

Create a PR/MR using your git platform:
  - GitHub: gh pr create --title "[title following project conventions]"
  - GitLab: glab mr create --title "[title]"
  - Other: Create via your platform's web interface

Note: Skipping refactoring means the code works but may not be optimized.
Consider refactoring before merging for better code quality.
```
