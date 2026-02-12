# Refactor Command

## Objective
Optimize, document, and clean up the implementation while keeping tests green (Green → Refactor phase of TDD).

## Plan Mode

**IMPORTANT: Phase 2 (System Assessment) uses PLAN MODE.**

The refactoring process uses plan mode for strategic planning:
1. **Enter Plan Mode** for system assessment
2. Analyze implementation holistically across all files
3. Identify cross-cutting concerns and systemic improvements
4. Create coherent refactoring strategy with logical groupings
5. **Exit Plan Mode** to get user approval on strategy
6. Execute refactorings in implementation mode

**Rationale:**
- Refactoring should be strategic, not ad-hoc
- System-wide view prevents missing important patterns
- Coherent plan makes changes easier to review
- User approval before making changes

## Project Context

**Before starting, read `ai-context/current-work.md` for cached project discovery results.**

The `## Project Context` section contains the test command, lint command, format command, commit convention, and git platform discovered by `/start_work`. Use these values for:
- Running tests after each refactoring group
- Running linters and formatters
- Formatting commit messages
- Creating PRs/MRs on the right platform

**If `current-work.md` doesn't exist or has no Project Context section**, run the discovery protocol from `commands/_project_discovery.md` and cache the results.

## Context Budget
- Start: ~25-30% (implementation reference)
- End: ~35-40% (implementation + refactoring notes)
- Never exceed 45%

## Prerequisites
- Completed implementation: `ai-context/implementation/[date]_[ticket]_[feature]_implementation.md`
- All tests passing (GREEN state)
- Working feature

## Process

### Phase 0: Branch Safety Check

**Check current branch before starting.**

```bash
git branch --show-current
```

**If on `main` or `master`:**
```
⚠️  WARNING: You're on the main branch.

Plan mode (Phase 2 - System Assessment) is okay on main since it doesn't modify code.
However, Phase 4 (Execute Refactoring) requires a feature branch.

Recommendation:
  git checkout -b refactor/[ticket-id]-[feature-name]

Continue with plan mode? (y/n)
```

**If on a feature branch:**
```
✅ Current branch: [branch-name]
Proceeding with refactoring...
```

**Before Phase 4 (Execute Refactoring):**
If still on main at execution phase:
```
⚠️  STOP: Cannot execute refactoring on main branch.

Please switch to a feature branch:
  git checkout -b refactor/[ticket-id]-[feature-name]
```

---

### Phase 1: Load Implementation Context
1. Reference implementation: `@ai-context/implementation/[date]_[ticket]_[feature]_implementation.md`
2. Reference specification: `@ai-context/specs/[date]_[ticket]_[feature]_spec.md`
3. Identify files that were created or modified

### Phase 2: System Assessment (Plan Mode)

**IMPORTANT: Use Plan Mode for holistic refactoring assessment**

Before making any changes, analyze the implementation as a complete system:

#### Step 1: Review All Modified Files
Read all files that were created or modified during implementation:
- Backend handlers
- Database queries
- Frontend components
- Hooks and utilities
- Test files

#### Step 2: Identify Systemic Issues
Look for patterns across the entire implementation:

**Cross-Cutting Concerns:**
- [ ] Are there patterns repeated across multiple files?
- [ ] Is error handling consistent across layers?
- [ ] Do components share similar logic that could be extracted?
- [ ] Are naming conventions consistent throughout?

**Architectural Coherence:**
- [ ] Does the implementation follow existing patterns in the codebase?
- [ ] Are layers (DB → Service → Handler → Frontend) properly separated?
- [ ] Are abstractions at the right level?
- [ ] Is the dependency flow unidirectional?

**Interface Design:**
- [ ] Are API contracts clear and well-defined?
- [ ] Do data models make sense across the stack?
- [ ] Are types/interfaces reused appropriately?
- [ ] Is there a clear contract between frontend and backend?

**Code Quality Patterns:**
- [ ] Which files have the most duplication?
- [ ] Where is complexity highest?
- [ ] Which areas need the most documentation?
- [ ] What security/performance issues span multiple files?

#### Step 3: Create Refactoring Strategy

Group improvements into coherent themes:

**Example Themes:**
1. **Error Handling Standardization** (affects handlers + frontend)
   - Wrap all database errors consistently
   - Standardize error response format
   - Update frontend to display unified error messages

2. **Validation Logic Extraction** (affects handlers + utilities)
   - Extract repeated validation into shared helpers
   - Create consistent validation patterns
   - Add comprehensive validation tests

3. **Component Architecture** (affects frontend structure)
   - Extract repeated UI patterns into shared components
   - Consolidate data fetching logic into hooks
   - Standardize loading/error states

4. **Documentation Pass** (affects all files)
   - Add documentation to all public interfaces (following project conventions)
   - Document complex algorithms
   - Update README with usage examples

#### Step 4: Define Refactoring Order

Prioritize refactorings by:
1. **Risk Level** - Low risk first (docs, naming) → Higher risk later (logic changes)
2. **Dependencies** - Foundational changes first (shared utils) → Dependent changes later
3. **Impact** - High-impact improvements first (security, performance)

**Example Order:**
```markdown
## Refactoring Plan

### Phase A: Foundation (Low Risk)
1. Extract shared validation helpers (service/helpers/validation.go)
2. Extract shared UI components (discover location from existing shared components)
3. Standardize error types (service/errors/types.go)

### Phase B: Integration (Medium Risk)
4. Update all handlers to use new validation helpers
5. Update all frontend components to use shared components
6. Standardize error handling across handlers

### Phase C: Polish (Low Risk)
7. Add comprehensive documentation
8. Improve naming consistency
9. Add usage examples

### Phase D: Optimization (Medium Risk - Optional)
10. Add database index for common queries
11. Add memoization/caching for expensive computations (if applicable)
```

#### Step 5: Exit Plan Mode

Use ExitPlanMode to present your refactoring strategy for approval:
- Show systemic issues identified
- Present coherent refactoring themes
- Explain the order and rationale
- Get user approval before making changes

**Rationale for Plan Mode:**
- Refactoring should be strategic, not ad-hoc
- User should approve the approach before changes
- Systemic view prevents missing cross-cutting improvements
- Coherent plan makes review easier

---

### Phase 3: Refactoring Checklist

Use this checklist during system assessment to identify issues:

#### Code Quality
- [ ] **Remove duplication**: Extract common logic into shared functions
- [ ] **Improve naming**: Ensure variables/functions have clear, descriptive names
- [ ] **Simplify logic**: Replace complex conditionals with early returns or guard clauses
- [ ] **Extract methods**: Break down large functions into smaller, focused ones
- [ ] **Remove dead code**: Delete unused variables, imports, or functions
- [ ] **Fix TODOs**: Address or remove TODO comments

#### Documentation
- [ ] **Function comments**: Follow the project's documentation conventions (discover from existing code)
- [ ] **README updates**: Update relevant README files if needed
- [ ] **Inline comments**: Add comments for non-obvious logic only
- [ ] **Examples**: Add usage examples if creating new public API

#### Error Handling
- [ ] **Consistent errors**: Use consistent error types and messages
- [ ] **Error wrapping**: Wrap errors with context following the project's error handling pattern
- [ ] **User-friendly errors**: Ensure user-facing surfaces show helpful error messages
- [ ] **Logging**: Add appropriate logging for debugging (without over-logging)

#### Performance
- [ ] **Database queries**: Review for N+1 queries or missing indexes
- [ ] **Memory allocation**: Check for unnecessary allocations in hot paths
- [ ] **Frontend rendering**: Ensure proper memoization/caching if needed
- [ ] **API calls**: Batch requests or add caching if appropriate

#### Security
- [ ] **Input validation**: All user inputs validated per project conventions
- [ ] **SQL injection**: Using parameterized queries (verify ORM/query builder handles this)
- [ ] **XSS protection**: Frontend sanitizes user content if rendered
- [ ] **Auth/authz**: Proper authorization checks in place
- [ ] **Sensitive data**: No secrets or sensitive data in logs

#### Testing
- [ ] **Test coverage**: Adequate coverage for new code
- [ ] **Test clarity**: Test names clearly describe what they test
- [ ] **Test independence**: Tests don't depend on each other
- [ ] **Mock data**: Test fixtures are realistic and maintainable
- [ ] **Clean up test code**: Apply refactoring to tests too

#### Repository Conventions
- [ ] **Code formatting**: Run the project's formatter (discover from Makefile, CI config, or editor config)
- [ ] **Linting**: Pass the project's linter (discover from Makefile, CI config, or lint config files)
- [ ] **Import order**: Imports organized per project conventions
- [ ] **File organization**: Files in correct directories per project conventions
- [ ] **Naming conventions**: Follow the project's established naming patterns (discover from existing code)

---

### Phase 4: Execute Refactoring Plan (Implementation Mode)

After plan approval, execute refactorings in the planned order.

Make improvements one group at a time, running tests after each logical group:

```bash
# After each refactoring change, run the repository's test and lint commands
# Discover these from Makefile, package.json, README.md, or CI config
[test command]               # Run all tests
[lint command]               # Run linters
```

**CRITICAL**: Tests must stay GREEN throughout refactoring. If a test fails, undo the change.

**Example: Executing a Refactoring Group**
```bash
# Phase A: Foundation - Extract shared helpers
# 1. Create shared helper file (discover location from repo patterns)
# 2. Run tests to verify no regressions
# 3. Update callers to use new helpers
# 4. Run tests again
# 5. Commit: "refactor: extract shared helpers"

# Phase B: Integration - Update all callers
# 1. Update first file to use new patterns
# 2. Run tests to verify
# 3. Update next file
# 4. Run tests to verify
# 5. Commit: "refactor: standardize [pattern]"
```

### Phase 5: Refactoring Principles

Apply these universal refactoring principles using the project's actual code patterns:

#### Extract Duplicated Logic
When the same logic appears in multiple places, extract it into a shared helper function. Find examples of shared helpers in the existing codebase and follow that pattern for location and naming.

#### Improve Naming
Replace vague names (`getData`, `process`, `handle`) with specific, descriptive names that communicate intent (`getEntityByID`, `validateUserInput`, `handleAuthCallback`). Follow the naming conventions already used in the project.

#### Simplify with Guard Clauses
Replace deeply nested conditionals with early returns. Check for error conditions first and return early, leaving the happy path as the main flow.

#### Wrap Errors with Context
When catching or returning errors, add context about what operation failed. Follow the project's error handling pattern (discovered from existing code).

**For all refactorings:** Find similar code in the repository and use it as a reference for style, naming, and structure. Don't introduce patterns that are foreign to the codebase.

### Phase 6: Documentation Pass
Add or improve documentation following the project's existing conventions:

1. **Discover the project's doc style** — Read existing documented functions/classes to understand the expected format (e.g., JSDoc, docstrings, doc comments, XML docs)
2. **Document public interfaces** — Add documentation to all new public functions, methods, types, and classes
3. **Use the same style** — Match the documentation format already used in the codebase
4. **Focus on "why"** — Document intent and edge cases, not obvious behavior

### Phase 7: Create Refactoring Document
Save refactoring notes to `ai-context/refactoring/[date]_[ticket]_[feature]_refactoring.md`:

```markdown
# Refactoring: [Feature Name]

**Created**: [Date]
**Implementation**: @ai-context/implementation/[date]_[ticket]_[feature]_implementation.md

## Changes Made

### 1. Code Quality Improvements
- Extracted `validateField()` helper to eliminate duplication
- Renamed `GetData()` to `GetEntityByID()` for clarity
- Simplified `ProcessRequest()` using guard clauses

### 2. Documentation Added
- Added documentation to all public functions following project conventions
- Updated README with usage examples

### 3. Performance Optimizations
- Added database index on `entities.user_id` for faster lookups
- Memoized expensive computation in `useEntityData` hook

### 4. Error Handling Improvements
- Wrapped all database errors with context
- Added user-friendly error messages in frontend
- Standardized error response format

### 5. Security Enhancements
- Added input sanitization for user-generated content
- Verified authorization checks on all endpoints

## Files Modified
1. `[path/to/file]` - Refactored logic, added docs
2. `[path/to/file]` - Improved naming, added memoization
3. `[path/to/file]` - Performance improvement

## Test Results
All tests remain GREEN after refactoring:
```
[paste actual test output showing all tests pass]
```

## Lint Results
```bash
[paste actual lint output showing no issues]
```

## Metrics

### Before Refactoring
- Cyclomatic complexity: 12
- Lines of code: 245
- Test coverage: 82%

### After Refactoring
- Cyclomatic complexity: 6
- Lines of code: 198
- Test coverage: 84%

## Lessons Learned
- Early returns make code more readable than nested conditions
- Consistent error wrapping helps with debugging
- Extracting helpers reduces duplication and improves testability

## Ready for Review
- ✅ All tests passing
- ✅ Linters passing
- ✅ Documentation complete
- ✅ Code quality improved
- ✅ No performance regressions
```

### Phase 8: Final Verification
Before committing, run the repository's full verification suite.

Discover commands from `Makefile`, `package.json`, `README.md`, or CI config:
```bash
# Run all tests (with race detection if available)
[test command]

# Run linters
[lint command]

# Check formatting
[format check command]

# Run integration tests if available
[integration test command]
```

### Phase 9: Commit Refactoring
```bash
# Stage changes
git add [modified files]

# Commit following the project's commit convention (discovered from git log)
# Example using conventional commits:
git commit -m "refactor(scope): optimize and document [feature]

- Extracted validation helpers to reduce duplication
- Improved error handling with wrapped contexts
- Added comprehensive documentation

Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Success Criteria
1. ✅ All tests still passing (GREEN)
2. ✅ Linters passing
3. ✅ Code is more readable and maintainable
4. ✅ Documentation is comprehensive
5. ✅ No performance regressions
6. ✅ Security best practices followed
7. ✅ Refactoring document created
8. ✅ Changes committed
9. ✅ Context under 40%

## Workflow Complete - Create Pull Request

**After refactoring is complete and all tests still pass, the feature is ready for review.**

Present this to the user:

```
🎉 Workflow Complete!

Refactoring saved to:
  ai-context/refactoring/[date]_[ticket]_[feature]_refactoring.md

Status:
  ✅ All tests passing (GREEN state)
  ✅ Code refactored and optimized
  ✅ Documentation added
  ✅ Ready for review

Full Workflow Completed:
  ✅ Phase 1: Specification
  ✅ Phase 2: Tests (RED)
  ✅ Phase 3: Research
  ✅ Phase 4: Implementation (GREEN)
  ✅ Phase 5: Refactor (GREEN)

─────────────────────────────────────────────────
Next Step: Create Pull Request
─────────────────────────────────────────────────

Your feature is complete and ready for code review!

Create a PR/MR using your git platform's tool or web interface.

Would you like me to help create a pull request?
  → Yes - I'll guide you through PR creation
  → No - I'll provide the command, you create it manually
```

**Use AskUserQuestion:**
- Question: "Create pull request now?"
- Options:
  1. "Yes, help me create a PR" - Provide PR creation guidance
  2. "No, I'll create it manually" - Just show the command

**If user selects "Yes":**
```
Great! Let's create a pull request.

I'll need a few details:

1. PR Title (following project's commit/PR conventions):
   [type](scope): [brief feature description]

2. PR Description:
   I can generate a comprehensive PR description including:
   - Summary of changes
   - Testing performed
   - Link to specification
   - All workflow artifacts

Should I create the PR with auto-generated description?
```

Then if they agree, detect the git platform and run the appropriate command:
- **GitHub:** `gh pr create --title "[title]" --body "[description]"`
- **GitLab:** `glab mr create --title "[title]" --description "[description]"`
- **Other:** Provide the title and description for the user to create manually via web interface

**If user selects "No":**
```
No problem! Create your PR/MR through your platform's CLI or web interface.

Great work on completing the full TDD workflow!
```

---

## Summary

The full Test-First AI Development Workflow is now complete:

1. ✅ **Spec** → Requirements gathered and approved
2. ✅ **Test** → Failing tests created (TDD RED)
3. ✅ **Research** → Implementation planned
4. ✅ **Implement** → Tests passing (TDD GREEN)
5. ✅ **Refactor** → Code optimized (TDD REFACTOR)

**Artifacts created:**
- `ai-context/specs/[date]_[ticket]_[feature]_spec.md`
- `ai-context/tests/[date]_[ticket]_[feature]_tests.md`
- `ai-context/research/[date]_[ticket]_[feature]_research.md`
- `ai-context/implementation/[date]_[ticket]_[feature]_implementation.md`
- `ai-context/refactoring/[date]_[ticket]_[feature]_refactoring.md`

**All code:**
- Tested comprehensively
- Documented thoroughly
- Following repository patterns
- Ready for production
