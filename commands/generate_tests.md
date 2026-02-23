# Generate Tests Command

## Objective
Create comprehensive, failing tests FIRST based on a specification, following true TDD principles.

## Project Context

**Before starting, read `ai-context/project-context.md` for cached project discovery results.**

This file contains the language, test framework, test command, and commit convention discovered by `/start_work`. Use these values for:
- Choosing the right test framework and assertion style
- Running tests with the correct command
- Formatting commit messages

**If `project-context.md` doesn't exist**, run the discovery protocol from `commands/_project_discovery.md` and create it.

## Workflow Boundaries

**Full reference: `commands/_boundaries.md`**

- **ALWAYS**: Read `project-context.md` for project context; read `current-work.md` for work state; discover test patterns from existing tests
- **ALWAYS**: Verify not on main branch before creating test files; commit tests after verification
- **ASK**: Clarify test scope and approach with user (unit, integration, mocks)
- **ASK**: If a spec requirement cannot be tested, flag it for user decision
- **NEVER**: Write implementation code — only test code in this phase
- **NEVER**: Auto-invoke `/research_implementation` via Skill tool — context isolation requires `/clear` first
- **NEVER**: Modify existing tests that aren't part of this feature
- **NEVER**: Exceed 50% context budget in this phase

## Context Budget
- Start: ~25-30% (spec file reference)
- End: ~40-45% (spec + generated tests)
- Never exceed 50%

## Prerequisites
- A completed specification file in `ai-context/specs/[date]_[ticket]_[feature]_spec.md`
- Understanding of the project's testing frameworks (from `project-context.md`)

## Process

### Phase 0: Branch Safety Check

**CRITICAL: Verify we're not on main branch before creating test files.**

```bash
git branch --show-current
```

**If on `main` or `master`:**
```
⚠️  STOP: You're on the main branch.

We don't write code (including tests) on main.

Please create or switch to a feature branch:
  git checkout -b feat/[ticket-id]-[feature-name]

Then run this command again.
```

**If on a feature branch:**
```
✅ Current branch: [branch-name]
Proceeding with test generation...
```

---

### Phase 1: Analyze Specification
1. Read the specification file provided via `@ai-context/specs/[date]_[ticket]_[feature]_spec.md`
   - If the spec has a `## Spec Summary` section, read the summary first, then selectively load only the sections relevant to test generation
2. Identify all functional requirements, edge cases, and error scenarios
3. Determine which layer(s) need tests:
   - **Backend**: Service handlers, database queries, business logic
   - **Frontend**: Components, hooks, API integration
   - **Integration**: End-to-end workflows

### Phase 2: Design Test Strategy
Ask the user to clarify:
1. **Test Scope**: Which layers to test (backend, frontend, integration)?
2. **Test Approach**:
   - Unit tests only?
   - Integration tests needed?
   - Mock external dependencies?
3. **Coverage Goals**: Specific scenarios to prioritize?

### Phase 3: Generate Failing Tests
Create tests that will FAIL initially (code doesn't exist yet).

**CRITICAL: Discover test patterns from the repository before writing tests.**

#### Step 1: Find Existing Test Files
Search for existing tests to understand conventions:
- What testing framework is used?
- Where are test files located (colocated or separate directory)?
- What naming conventions are used (`*_test.go`, `*.test.tsx`, `*.spec.ts`)?
- How are test fixtures and mocks set up?
- What helper utilities exist for testing?

Use Glob and Grep to discover:
```
**/*_test.*
**/*.test.*
**/*.spec.*
```

#### Step 2: Read Similar Tests
Find and read test files for features similar to the one being built. Use these as templates for:
- Package/import structure
- Test setup and teardown patterns
- Assertion library and style
- Mock/fixture patterns

#### Step 3: Write Failing Tests Following Discovered Patterns
Create test files in the same locations and following the same conventions as existing tests.

Each test should:
- Cover a requirement from the specification
- Follow the repository's test naming conventions
- Use the repository's test framework and assertion style
- FAIL because the implementation doesn't exist yet

Test categories to cover:
- **Happy path**: Core functionality works as specified
- **Edge cases**: Boundary conditions and unusual scenarios
- **Error handling**: Invalid input, missing data, permission errors

#### Step 3b: Populate Requirements Traceability

After writing tests, map each test back to its specification requirement:

1. **Assign test IDs** using the pattern `T-[REQ-ID]-[seq]`:
   - `T-REQ-1-01`, `T-REQ-1-02` — tests for REQ-1
   - `T-EDGE-1-01` — test for EDGE-1
   - `T-ERR-1-01` — test for ERR-1

2. **Add requirement reference comments** to each test function:
   ```
   // Test ID: T-REQ-1-01 | Requirement: REQ-1
   // Test ID: T-EDGE-2-01 | Requirement: EDGE-2
   ```
   Use the comment syntax appropriate for the project's language.

3. **Update the spec file's traceability table**:
   - Fill in the "Test ID(s)" column with the assigned test IDs
   - Set status from "Pending" to "Tested" for each covered requirement
   - Example: `| REQ-1 | Create entity via API | T-REQ-1-01, T-REQ-1-02 | Tested |`

4. **Flag requirements with no test coverage**:
   - If any requirement has no corresponding test, note it in the test plan
   - Ask the user whether the gap is intentional or needs additional tests

#### Step 4: Verify Database Tests (if applicable)
If the feature involves database operations, discover test patterns for data access:
- Find existing database/repository test files in the codebase
- Follow the same setup/teardown patterns (test databases, fixtures, transactions)
- Use the same assertion library and style as other data access tests
- Tests should fail because the implementation doesn't exist yet

### Phase 4: Document Test Plan
Create a test plan document in `ai-context/tests/[date]_[ticket]_[feature]_tests.md`:

```markdown
# Test Plan: [Feature Name]

**Created**: [Date]
**Specification**: @ai-context/specs/[date]_[ticket]_[feature]_spec.md

## Test Coverage

### Unit Tests
- [ ] Test 1: Description (maps to spec requirement X)
- [ ] Test 2: Description (maps to spec requirement Y)
- [ ] Edge Case 1: Description
- [ ] Error Scenario 1: Description

### Integration Tests (if applicable)
- [ ] Integration flow 1
- [ ] Integration flow 2

## Traceability Matrix

| Requirement ID | Test ID(s) | Test File | Status |
|---|---|---|---|
| REQ-1 | T-REQ-1-01, T-REQ-1-02 | [path/to/test_file] | Tested |
| EDGE-1 | T-EDGE-1-01 | [path/to/test_file] | Tested |
| ERR-1 | T-ERR-1-01 | [path/to/test_file] | Tested |

**Uncovered requirements**: [list any requirements without tests, or "None"]

## Test Files Created
- [List actual test files created, discovering locations from existing test patterns in the repo]

## Running Tests
Discover test commands from the repository (check `Makefile`, `package.json`, `README.md`, or CI config):
```bash
[actual test command for this repository]
```

## Expected Initial State
All tests should FAIL because implementation doesn't exist yet.

## Next Steps
1. Verify tests fail (red)
2. Proceed to Research Phase
3. Implement code to make tests pass (green)
```

### Phase 5: Verify Tests Fail
1. Run the tests to confirm they fail as expected
2. Commit the tests using the project's commit convention (e.g., `git add [test files] && git commit -m "[commit message following project conventions]"`)
3. Create test plan document in `ai-context/tests/`

## Output
- Test files in appropriate locations (discover from existing test patterns in the repo)
- Test plan document in `ai-context/tests/[date]_[ticket]_[feature]_tests.md`
- All tests should be RED (failing)

## Context Management
- Reference spec file with `@ai-context/specs/[date]_[ticket]_[feature]_spec.md`
- Save test plan to `ai-context/tests/`
- After completion, clear context before Research Phase

## Success Criteria
1. ✅ Tests cover all requirements from specification
2. ✅ Tests follow repository conventions (see AGENTS.md)
3. ✅ All tests fail initially (true TDD red state)
4. ✅ Test plan document created
5. ✅ Tests committed to git
6. ✅ Context under 45%

---

## Phase Complete

After tests are created, verified as failing, committed, and test plan documented, present:

```
✅ Tests Generated Successfully!

Test files created:
  - [list of test files created]

Test plan saved to:
  ai-context/tests/[date]_[ticket]_[feature]_tests.md

Status: All tests failing ✓ (RED state — this is correct for TDD)

CONTEXT ISOLATION — run /clear before continuing.
The researcher must not carry the test writer's analysis.

Next command (after /clear):
  /research_implementation @ai-context/specs/[date]_[ticket]_[feature]_spec.md
```

**Do NOT invoke the Skill tool or offer to auto-run the next phase.** Context isolation requires a fresh context for implementation research.
