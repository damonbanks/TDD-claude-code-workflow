# Implement Command

## Objective
Write code to make the failing tests pass, following the research plan and TDD principles (Red → Green).

## Project Context

**Before starting, read `ai-context/project-context.md` for cached project discovery results.**

This file contains the test command, lint command, build command, and other tooling discovered by `/start_work`. Use these values for:
- Running tests (use the cached test command, not a guess)
- Running linters and formatters after changes
- Running code generation commands
- Formatting commit messages

**If `project-context.md` doesn't exist**, run the discovery protocol from `commands/_project_discovery.md` and create it.

## Workflow Boundaries

**Full reference: `commands/_boundaries.md`**

- **ALWAYS**: Read `project-context.md` for project context; read `current-work.md` for work state; run tests after each implementation step
- **ALWAYS**: Verify not on main branch before writing code; follow research plan's implementation order
- **ASK**: If implementation requires deviating from the spec, flag for user approval
- **ASK**: If new dependencies are needed, get user approval before adding
- **ASK**: If a test seems incorrect, flag it — don't modify tests to make them pass
- **NEVER**: Modify tests to make them pass — adjust implementation, not tests
- **NEVER**: Auto-invoke `/refactor` via Skill tool — context isolation requires `/clear` first
- **NEVER**: Exceed 65% context budget in this phase

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
   - If the spec has a `## Spec Summary` section, read the summary first, then selectively load only the sections relevant to implementation
3. Review test files to understand what needs to pass
4. **Establish test baseline**: Run the project's test command to determine starting state
   - Tests from **previous layers** should be GREEN (passing) — these are the regression baseline
   - Tests from the **current layer** should be RED (failing) — these are what you need to make pass
   - If any previously-GREEN tests are now RED, flag as a regression and investigate before proceeding

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

**Regression awareness**: After each step, verify that previously-passing tests (from earlier layers) remain GREEN. If a previously-passing test breaks, stop and fix the regression before continuing with new work.

### Phase 4: Fix Failing Tests
If tests still fail:
1. Read test output carefully
2. Identify what the test expects vs. what the code does
3. Adjust implementation (NOT tests)
4. Re-run tests
5. Repeat until GREEN

### Phase 4b: Verify Requirement Coverage

After all tests pass, cross-check the traceability matrix to ensure complete coverage:

1. **Read the spec's `## Requirements Traceability` table** (or the test plan's `## Traceability Matrix`)
2. **Verify every row has a passing test** — each requirement should map to at least one green test
3. **Update the spec traceability table**: Change status from "Tested" to "Verified" for each requirement whose tests pass
4. **Report unverified requirements** to the user:
   - Requirements still at "Pending" or "Tested" status
   - Requirements marked "N/A" (confirm with user)
   - Any gaps between spec and passing tests

### Phase 4c: Spec Conformance Self-Check

After verifying requirement coverage, perform a conformance check against the full specification:

1. **Re-read the specification** — load the spec file (or summary + relevant sections)
2. **Walk through each acceptance criterion** in every REQ, EDGE, and ERR:
   - Does the implementation satisfy the criterion?
   - Is the behavior testable and verified?
3. **Check non-functional requirements**:
   - Performance: Does the implementation meet response time and throughput goals?
   - Security: Are authentication, authorization, and input validation in place?
   - Error handling: Do error responses match the spec's expected format?
4. **Check API contracts and data models**:
   - Do endpoints match the spec's method, route, request, and response definitions?
   - Do data models match the spec's schema definitions?
5. **Output a conformance summary**:
   ```
   ## Spec Conformance Summary
   | Requirement | Status | Notes |
   |---|---|---|
   | REQ-1 | PASS | All acceptance criteria met |
   | REQ-2 | PASS | |
   | EDGE-1 | DEVIATION | [describe deviation] |
   | ERR-1 | PASS | |
   | Performance | PASS | Response time under target |
   | Security | PASS | Auth checks in place |
   ```
6. **Flag deviations and ask the user** about any gaps:
   - Deviations that were necessary (explain why)
   - Ambiguous requirements that need clarification
   - Requirements that were impossible to verify automatically

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

## Next Phase
After implementation is complete and all tests pass, proceed to refactoring.
```

### Phase 5.5: Next TDD Layer

After documenting the implementation, check for remaining test layers:

1. **Read the spec's `## Test Plan`** to identify all defined layers
2. **Read the test plan's `## Layer Status`** (in `ai-context/tests/`) to check which layers have been generated
3. **If remaining layers exist**, use AskUserQuestion:
   - **Question**: "All current-layer tests are passing. What would you like to do next?"
   - **Options**:
     1. "Add more tests (next layer: [layer name])" — next step is `/generate_tests`
     2. "Proceed to refactoring" — next step is `/refactor`
     3. "I'm done" — end workflow

Record the user's choice for the Phase Complete message.

---

### Phase 6: Phase Complete

After implementation is complete, all tests pass, the implementation document is saved, and changes are committed, present:

```
✅ Implementation Complete!

Implementation saved to:
  ai-context/implementation/[date]_[ticket]_[feature]_implementation.md

Status:
  ✅ All tests passing (GREEN state)
  ✅ Feature implemented
  ✅ Code committed
```

**If user chose "Add more tests"** (from Phase 5.5):
```
CONTEXT ISOLATION — run /clear before continuing.
Next layer of tests is ready to be generated.

Next command (after /clear):
  /generate_tests @ai-context/specs/[date]_[ticket]_[feature]_spec.md
```

**If user chose "Proceed to refactoring"** (or no remaining layers):
```
CONTEXT ISOLATION — run /clear before continuing.
The refactorer should assess code quality with fresh eyes.

Next command (after /clear):
  /refactor @ai-context/implementation/[date]_[ticket]_[feature]_implementation.md
```

**If user chose "I'm done":**
```
All done! You can create a PR when ready, or run /finish_work after merge.
```

**Do NOT invoke the Skill tool or offer to auto-run the next phase.** Context isolation requires a fresh context.
