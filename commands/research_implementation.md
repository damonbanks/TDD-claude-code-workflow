# Research Implementation Command

## Objective
Analyze the codebase to determine what needs to be changed to make the failing tests pass, following TDD principles.

## Pattern Discovery Philosophy

**CRITICAL: This command is pattern-discovery based, not prescriptive.**

Every repository is unique:
- Different folder structures (years of evolution)
- Different architectural patterns (layered, feature-based, service-oriented)
- Different conventions (naming, organization, testing)
- Tests colocated with code OR in separate directories
- Various locations (`src/scenes`, `src/services`, `src/utils`, `src/providers`, `service/handlers`, etc.)

**Your job is to:**
1. **Discover** where test files were created
2. **Analyze** existing patterns in the codebase
3. **Follow** the repository's conventions
4. **Adapt** your implementation to match the existing style

**DO NOT assume folder structures or conventions.**

## Project Context

**Before starting, read `ai-context/current-work.md` for cached project discovery results.**

The `## Project Context` section contains the language, test/build/lint commands, and commit convention discovered by `/start_work`. Use these values when documenting build commands and test commands in the research document — don't re-discover what's already cached.

**If `current-work.md` doesn't exist or has no Project Context section**, run the discovery protocol from `commands/_project_discovery.md` and cache the results.

## Context Budget
- Start: ~30-35% (spec + test references)
- End: ~55-60% (spec + tests + research findings)
- Never exceed 65%

## Prerequisites
- Completed specification: `ai-context/specs/[date]_[ticket]_[feature]_spec.md`
- Failing tests: Created in previous phase
- Test plan: `ai-context/tests/[date]_[ticket]_[feature]_tests.md`

## Process

### Phase 1: Discover and Load Context

#### Step 1: Find the Test Files
Discover which test files were created in the generate_tests phase:

**Option A: Check Git Status**
```bash
git status --short
# Look for newly created test files (files with "A  " or "??" prefix)
# or files modified in the test generation phase (files with "M  " prefix)
```

**Option B: Check Git History**
```bash
git log --oneline --name-only -1
# Shows files changed in the most recent commit (if tests were committed)

git diff --name-only HEAD~1
# Shows files changed compared to previous commit
```

**Option C: Check Test Plan**
Read the test plan document which should list all test files created:
```
@ai-context/tests/[date]_[ticket]_[feature]_tests.md
```

**Option D: Run Test Suite**
```bash
# Discover test command from Makefile or package.json
# Then run tests to see which fail
[test-command]

# Examples:
go test ./... -v
npm test
pnpm test

# Failed tests will show their file locations
```

**Option E: Search for Test Files**
Use Glob to find test files related to the feature:
```
**/*[feature-name]*.test.*
**/*[feature-name]*_test.*
**/*[feature-name]*.spec.*
```

**Recommended Approach:**
1. Start with Option B (git history) or Option C (test plan) - most reliable
2. Fall back to Option D (run tests) - shows actual failing tests
3. Use Option E (search) - if naming is consistent

#### Step 2: Load Context
1. Reference the specification: `@ai-context/specs/[date]_[ticket]_[feature]_spec.md`
2. Reference the test plan: `@ai-context/tests/[date]_[ticket]_[feature]_tests.md`
3. Review the test files identified in Step 1
4. **Don't load entire codebase yet** - start with just these files

### Phase 2: Identify Implementation Scope

Based on the failing tests, determine what needs to be created or modified.

**IMPORTANT: Discover actual structure from the repository - don't assume folder conventions.**

#### Analyze the Test Files
For each test file discovered:
1. What is it testing? (component, service, handler, utility, etc.)
2. Where is it located in the repository structure?
3. What patterns does it follow for test organization?
4. What imports does it expect to exist?
5. What interfaces/contracts does it expect?

#### Map Implementation Needs
Based on test analysis:

**Backend Implementation:**
- [ ] New API definitions (protobuf, GraphQL, REST)?
- [ ] New database migrations (if tests expect schema)?
- [ ] New database queries/operations?
- [ ] New service/business logic (handlers, services, controllers)?
- [ ] Updates to service composition/wiring?
- [ ] New utilities or helpers?

**Frontend Implementation:**
- [ ] New API client methods?
- [ ] New UI components?
- [ ] New hooks or state management?
- [ ] New pages or routes?
- [ ] New types/interfaces?
- [ ] Translations or i18n?

**Cross-Cutting:**
- [ ] Configuration changes?
- [ ] External dependencies?
- [ ] Environment variables?

**Note:** Folder paths will be discovered from existing patterns in Phase 3.

### Phase 3: Discover Repository Patterns

**CRITICAL: This repository has evolved over years with different conventions. Discover patterns from the actual codebase, don't assume folder structures.**

#### Step 1: Find Similar Existing Implementations

Use the test files' locations as clues to find similar code:

**Example:** If test is at `src/services/auth/AuthService.test.ts`
- Look for the implementation: `src/services/auth/AuthService.ts`
- Find similar services in: `src/services/*/`
- Understand the service pattern used

**Discovery Questions:**
1. **Where are tests located?**
   - Next to the code they test (colocation)?
   - In separate test directories?
   - Mixed patterns?

2. **What naming conventions are used?**
   - `*.test.ts` vs `*_test.go` vs `*.spec.ts`?
   - File naming: PascalCase, camelCase, kebab-case?

3. **What architectural patterns exist?**
   - How are services/handlers organized?
   - How are dependencies injected?
   - What patterns for data access?

#### Step 2: Search for Similar Features

**For Backend/Service Implementation:**
```bash
# Find similar handlers/services/controllers
Glob: **/*[similar-feature-name]*.[ext]
Grep: "class.*Service|func.*Handler|export.*Controller"
```

**For Frontend/UI Implementation:**
```bash
# Find similar components/hooks
Glob: **/*[similar-component-name]*.tsx
Grep: "export (const|function).*Component|use[A-Z]"
```

**For Database Implementation:**
```bash
# Find migrations and queries
Glob: **/migrations/*.sql
Glob: **/queries/*.sql
# Or find ORM/query patterns
Grep: "SELECT|INSERT|UPDATE" in relevant files
```

#### Step 3: Analyze Existing Patterns

For each similar implementation found:
1. **Read the file** to understand the pattern
2. **Note the structure** - how is it organized?
3. **Identify dependencies** - how are they injected/imported?
4. **Check composition** - how does it integrate with the system?
5. **Look for conventions** - naming, error handling, testing

#### Step 4: Document Repository-Specific Patterns

**Example patterns to capture:**
```markdown
## Repository Patterns Discovered

### Test Organization
- Tests are colocated with source files
- Pattern: `[Component].tsx` → `[Component].test.tsx`
- Location examples:
  - `src/scenes/Dashboard/Dashboard.test.tsx`
  - `src/services/api/ApiService.test.ts`
  - `src/utils/validation/validator.test.ts`

### Service Pattern (from existing code)
- Location: `src/services/[ServiceName]/`
- Factory pattern with dependency injection
- Example from `src/services/existing/ExistingService.ts`

### Component Pattern (from existing code)
- Location: Various (`src/scenes/`, `src/components/`, feature folders)
- Functional components with hooks
- Props interface defined above component
- Example from `src/scenes/existing/ExistingComponent.tsx`
```

### Phase 4: Determine Implementation Order

Based on discovered patterns and dependencies, map out the implementation order.

**IMPORTANT: Order depends on the repository's actual architecture - discover it, don't assume it.**

#### Identify Dependency Chains

**Example for typical layered architecture:**
1. Database schema → Data access → Business logic → API → UI

**Example for feature-based architecture:**
1. Core logic → Integration points → UI components

**Example for service-oriented architecture:**
1. Service contracts → Service implementation → Service consumers

#### Determine Your Implementation Order

Based on the test files and discovered patterns:

1. **Foundation Layer** (if applicable)
   - Database migrations (if schema changes needed)
   - Data models/entities (if new types needed)
   - Generated code (protobuf, GraphQL, etc.)

2. **Core Logic Layer**
   - Business logic/services
   - Data access/repositories
   - Utilities/helpers

3. **Integration Layer**
   - API handlers/endpoints
   - Service composition/wiring
   - Middleware/interceptors

4. **Presentation Layer** (if applicable)
   - UI components
   - Hooks/state management
   - Routes/navigation

**Note:** Not all projects follow this layering. Adapt to your repository's actual structure.

### Phase 5: Document Research Findings
Create research document in `ai-context/research/[date]_[ticket]_[feature]_research.md`:

```markdown
# Implementation Research: [Feature Name]

**Created**: [Date]
**Specification**: @ai-context/specs/[date]_[ticket]_[feature]_spec.md
**Test Plan**: @ai-context/tests/[date]_[ticket]_[feature]_tests.md

## Test Files Discovered

### Generated Test Files (from generate_tests phase)
1. `[actual/path/to/test1.test.ts]` - Tests [what]
2. `[actual/path/to/test2_test.go]` - Tests [what]
3. `[actual/path/to/test3.spec.tsx]` - Tests [what]

### Test Organization Pattern
- **Location**: [Describe where tests are - colocated with code, separate test dirs, etc.]
- **Naming**: [Describe naming convention - *.test.*, *_test.*, *.spec.*, etc.]
- **Structure**: [Describe how tests are organized]

## Repository Patterns Discovered

### Architecture Style
- **Type**: [Layered, Feature-based, Service-oriented, Modular monolith, etc.]
- **Key Characteristics**: [What makes this repo unique]

### Code Organization
- **Services/Logic**: Found in `[actual/paths/discovered]`
- **UI Components**: Found in `[actual/paths/discovered]`
- **Data Access**: Found in `[actual/paths/discovered]`
- **Utilities**: Found in `[actual/paths/discovered]`

### Similar Implementations Found
- `[path/to/similar/feature1]` - Used as reference for [pattern]
- `[path/to/similar/feature2]` - Used as reference for [pattern]

## Implementation Scope

### Files to Create
1. `[actual/discovered/path]/[NewFile].[ext]` - Purpose
   - Location based on pattern from: `[reference/file]`
   - Follows convention: [describe convention]

2. `[actual/discovered/path]/[AnotherFile].[ext]` - Purpose
   - Location based on pattern from: `[reference/file]`

### Files to Modify
1. `[actual/path]/[ExistingFile].[ext]` - Changes needed
   - Add function/component: [name]
   - Update interface/type: [name]
   - Reference pattern from: `[similar/file]`

## Implementation Order

Based on discovered dependency chain:

1. **Step 1**: [First thing based on actual architecture]
   - File(s): `[actual/paths/discovered]`
   - Purpose: [describe what and why]
   - Pattern reference: `[path/to/similar/implementation]`
   - Command (if applicable): `[actual command if code generation needed]`

2. **Step 2**: [Second thing based on actual dependencies]
   - File(s): `[actual/paths/discovered]`
   - Purpose: [describe what and why]
   - Pattern reference: `[path/to/similar/implementation]`
   - Dependencies: [what it depends on from Step 1]

3. **Step 3**: [Continue with actual implementation order]
   - ...

[Continue with actual steps based on your repository's structure]

## Code Patterns Found

Document actual patterns discovered from the repository. For each pattern:

### Pattern 1: [Name] (from `path/to/reference/file`)
```
[Paste actual code snippet from the repo showing the pattern]
```
**When to use:** [Describe when this pattern applies to the new feature]

### Pattern 2: [Name] (from `path/to/reference/file`)
```
[Paste actual code snippet from the repo showing the pattern]
```
**When to use:** [Describe when this pattern applies]

### Pattern 3: [Name] (from `path/to/reference/file`)
```
[Paste actual code snippet from the repo showing the pattern]
```
**When to use:** [Describe when this pattern applies]

## Dependencies

### Internal Dependencies
- `package1` - Used for X
- `package2` - Used for Y

### External Dependencies (if new ones needed)
- `github.com/example/package` - Purpose
- Installation: `go get github.com/example/package`

## Testing Strategy

### Tests to Update
- [List test files discovered in Phase 1] - Should pass after implementation

### Test Data Needed
- Mock fixtures: [describe]
- Database seed data: [describe]

## Edge Cases & Considerations

### From Specification
1. **Edge Case 1**: [How to handle]
2. **Error Scenario 1**: [How to implement]

### Additional Considerations
- Performance: [any considerations]
- Security: [any considerations]
- Backward compatibility: [any considerations]

## Build & Test Commands

**IMPORTANT: Discover actual commands from the repository.**

### Discover Build Commands

Check these files for actual commands:
- `Makefile` - Look for targets like `build`, `generate`, `test`
- `package.json` - Look for scripts in `"scripts"` section
- `README.md` - Look for development/build instructions
- `.github/workflows/` - Look at CI/CD for commands used

### Common Patterns to Look For

**Dependency Management:**
```bash
# Discover from the project — common patterns:
go mod tidy           # Go
npm install           # Node (npm)
pnpm install          # Node (pnpm)
yarn install          # Node (yarn)
cargo build           # Rust
pip install -e .      # Python
bundle install        # Ruby
dotnet restore        # C#
mix deps.get          # Elixir
mvn install           # Java (Maven)
```

**Code Generation (if applicable):**
```bash
# Check Makefile, package.json, or build scripts for actual commands
# Examples: make generate, npm run codegen, protoc, sqlc generate
```

**Running Tests:**
```bash
# Discover actual test commands from repository
# Common patterns:
make test             # If Makefile exists
go test ./...         # Go
npm test              # Node
cargo test            # Rust
pytest                # Python
bundle exec rspec     # Ruby
dotnet test           # C#
mix test              # Elixir
mvn test              # Java
```

**Database Commands (if applicable):**
```bash
# Discover actual migration commands from Makefile, scripts, or README
```

### Document Discovered Commands

In your research document, include:
```markdown
## Repository Commands Discovered

### Test Command
`[actual command from repo]`

### Build Command (if applicable)
`[actual command from repo]`

### Code Generation (if applicable)
`[actual command from repo]`

### Development Server (if applicable)
`[actual command from repo]`
```

## Intelligent Auto-Advance to Next Phase

**After research is complete and saved, suggest the next step.**

Present this to the user:

```
✅ Implementation Research Complete!

Research saved to:
  ai-context/research/[date]_[ticket]_[feature]_research.md

Key findings:
  - [X] files to create
  - [Y] files to modify
  - Implementation order defined
  - Patterns discovered

─────────────────────────────────────────────────
Next Step: Implementation (Phase 4)
─────────────────────────────────────────────────

The next phase is to write code following the research plan to make
the failing tests pass. This is the core TDD GREEN phase.

Command:
  /implement @ai-context/specs/[date]_[ticket]_[feature]_spec.md --make-tests-pass

Would you like me to proceed to implementation?
  → Yes - I'll run the command automatically
  → No - I'll stop here, you can run it manually later
```

**Use AskUserQuestion:**
- Question: "Proceed to implementation phase?"
- Options:
  1. "Yes, start implementation now (Recommended)" - Auto-run `/implement`
  2. "No, I'll run it manually later" - Stop and provide command

**If user selects "Yes":**
```
Great! Starting implementation...

Running: /implement @ai-context/specs/[date]_[ticket]_[feature]_spec.md --make-tests-pass
```
Then invoke the Skill tool with:
- skill: "implement"
- args: "@ai-context/specs/[date]_[ticket]_[feature]_spec.md --make-tests-pass"

**If user selects "No":**
```
No problem! When you're ready, run:

  /implement @ai-context/specs/[date]_[ticket]_[feature]_spec.md --make-tests-pass

I'll be here when you need me.
```

---

## Context Management
- Keep under 60% by referencing `@ai-context/` files
- Clear context before Implementation Phase
