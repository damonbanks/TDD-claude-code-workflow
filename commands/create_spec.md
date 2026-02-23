# Create Specification Command

## Objective
Generate a comprehensive, testable specification document for a feature based on plain text user requirements. This spec will drive test generation and implementation in the Test-First AI Development Workflow.

## Plan Mode

**IMPORTANT: This command operates in PLAN MODE.**

When this command is invoked:
1. **Enter Plan Mode** immediately using the EnterPlanMode tool
2. Explore the codebase to understand existing patterns
3. Gather requirements through clarifying questions
4. Draft the specification
5. **Present for approval** using AskUserQuestion (NOT ExitPlanMode) to get user approval before proceeding

**Rationale for Plan Mode:**
- Specification is about planning, not implementation
- User should approve the spec before moving to tests
- Prevents premature commitment to approach
- Allows for course correction before investing in tests/code

**Why AskUserQuestion instead of ExitPlanMode:**
- AskUserQuestion lets us present spec-specific approval options
- ExitPlanMode's default options don't match the spec approval workflow

## Project Context

**Before starting, read `ai-context/current-work.md` for cached project discovery results.**

The `## Project Context` section contains the language, test framework, build/test/lint commands, git platform, and commit convention discovered by `/start_work`. Use these throughout this phase instead of guessing or re-discovering.

**If `current-work.md` doesn't exist or has no Project Context section**, run the discovery protocol from `commands/_project_discovery.md` and cache the results.

## Workflow Boundaries

**Full reference: `commands/_boundaries.md`**

- **ALWAYS**: Read `current-work.md` for project context; save spec to `ai-context/specs/`; follow discovered patterns
- **ALWAYS**: Enter Plan Mode before exploring; commit spec after approval
- **ASK**: User must approve specification before proceeding to test phase
- **ASK**: If requirements are ambiguous, ask clarifying questions — don't assume
- **ASK**: If a requirement seems infeasible, flag it for user decision
- **NEVER**: Skip the question phase (Phase 1) — gather requirements before writing
- **NEVER**: Auto-invoke `/generate_tests` via Skill tool — context isolation requires `/clear` first
- **NEVER**: Exceed 40% context budget in this phase

## Context Budget
- Start: ~20-25%
- End: ~30-35%
- **Never exceed 40%** in this phase

## Input Format

This command accepts plain text requirements:

```
/create_spec Add user authentication with OAuth2 and JWT tokens
```

## Two-Phase Process

### Phase 0A: Branch Awareness

**Note the current branch for context.**

```bash
git branch --show-current
```

**If on `main` or `master`:**
```
📋 Note: You're currently on the main branch.

This command only creates documentation (in plan mode), so it's safe.
However, subsequent phases (tests, implementation) will require a feature branch.

Recommended: Create a feature branch before continuing to later phases:
  git checkout -b feat/[ticket-id]-[feature-name]
```

**If on a feature branch:**
```
✅ Current branch: [branch-name]
```

---

### Phase 0B: Enter Plan Mode

**FIRST ACTION: Use EnterPlanMode tool**

This transitions into plan mode where you can:
- Explore the codebase without modifying files
- Read existing patterns and conventions
- Gather requirements through questions
- Draft specifications
- Get user approval before proceeding

## Two-Phase Process (Within Plan Mode)

### Phase 1: Gather Requirements

**Input**: Plain text requirements provided by the user

Before writing any specification, ask the user clarifying questions to understand the feature completely.

#### 1. Core Functionality
- What is the primary purpose of this feature?
- What problem does it solve?
- What are the main actions users can perform?

#### 2. User Stories
- Who will use this feature?
- What are their goals?
- Why do they need this functionality?

#### 3. Input/Output
- What data goes into the system?
- What data comes out?
- What formats are expected?

#### 4. Edge Cases
- What unusual scenarios might occur?
- What happens with invalid input?
- What are the boundary conditions?

#### 5. Success Criteria
- How do we know the feature works correctly?
- What are the acceptance criteria?
- What must be true for this to be considered "done"?

#### 6. Non-Functional Requirements
- **Performance**: Response time goals, throughput requirements
- **Security**: Authentication, authorization, data protection needs
- **Accessibility**: WCAG compliance, keyboard navigation, screen reader support
- **Scalability**: Expected load, growth projections

#### 7. Dependencies
- What existing code/systems does this interact with?
- Are there external APIs or services involved?
- What data does it depend on?

**CRITICAL**: Do not proceed to Phase 2 until you have clear answers to these questions. Use AskUserQuestion if needed.

### Phase 2: Create Specification Document

Once you have sufficient information, generate a comprehensive specification document with the following structure:

## Specification Template

```markdown
# Feature Specification: [Feature Name]

**Created**: [YYYY-MM-DD]
**Status**: Draft | Approved
**Ticket**: [TICKET-ID if applicable]

## Overview
[2-3 sentence summary of what this feature does and why it exists]

## User Stories
As a [user type], I want to [action] so that [benefit]

Examples:
- As an admin, I want to create new resources so that I can organize workspaces
- As a user, I want to view my dashboard so that I can access my data quickly

## Functional Requirements

### Core Behavior

**REQ-1**: [Clear, specific requirement]
- **Input**: [What data/parameters are provided]
- **Process**: [What the system does with the input]
- **Output**: [What the system returns or displays]
- **Acceptance Criteria**:
  - [ ] [Specific, testable criterion 1]
  - [ ] [Specific, testable criterion 2]
  - [ ] [Specific, testable criterion 3]

**REQ-2**: [Next requirement]
- **Input**: ...
- **Process**: ...
- **Output**: ...
- **Acceptance Criteria**:
  - [ ] ...

### Edge Cases

**EDGE-1**: [Describe the edge case scenario]
- **Scenario**: [When/how this situation occurs]
- **Expected Behavior**: [What the system should do]
- **Acceptance Criteria**:
  - [ ] [How to verify correct behavior]

**EDGE-2**: [Next edge case]
- **Scenario**: ...
- **Expected Behavior**: ...
- **Acceptance Criteria**:
  - [ ] ...

### Error Handling

**ERR-1**: [Error scenario description]
- **Trigger**: [What causes this error condition]
- **Expected Response**: [How the system responds - status code, error type, etc.]
- **User Experience**: [What the user sees - error message, UI state]
- **Recovery**: [How the user can resolve or retry]

**ERR-2**: [Next error scenario]
- **Trigger**: ...
- **Expected Response**: ...
- **User Experience**: ...
- **Recovery**: ...

## Non-Functional Requirements

### Performance
- API response time: [e.g., < 200ms for p95]
- Page load time: [e.g., < 2s for initial load]
- Concurrent users: [e.g., supports 100 concurrent users]
- Database query limits: [e.g., max 5 queries per request]

### Security
- Authentication: [e.g., requires valid JWT token]
- Authorization: [e.g., user must own the resource]
- Input validation: [e.g., all inputs validated per project conventions]
- Data protection: [e.g., sensitive data encrypted at rest]
- OWASP considerations: [e.g., XSS protection, SQL injection prevention]

### Accessibility
- Keyboard navigation: [e.g., all actions accessible via keyboard]
- Screen reader support: [e.g., proper ARIA labels]
- Color contrast: [e.g., WCAG AA compliance]
- Focus management: [e.g., logical focus order]

### Reliability
- Error handling: [e.g., graceful degradation]
- Data consistency: [e.g., ACID transactions]
- Idempotency: [e.g., safe to retry operations]

## Data Models

**Discover the data modeling patterns from the existing codebase.**

Define data models for each layer this feature touches, following existing conventions:
- **Database schema**: Table definitions, relationships, constraints
- **Backend types**: Structs, interfaces, or classes
- **API contracts**: Request/response definitions (REST, gRPC, GraphQL, etc.)
- **Frontend types**: TypeScript interfaces or types

## API Contracts

**Follow the API patterns already established in this repository.**

For each endpoint/method this feature requires:
- **Method/Route**: Name and path
- **Request**: Input parameters and validation rules
- **Response**: Output format
- **Errors**: Error conditions and response codes

## Implementation Layers

**IMPORTANT: Do not hardcode paths. Discover actual file locations from the codebase during the research phase.**

Identify which layers this feature touches:
- **Database**: Migrations, queries, models
- **API/Protocol**: API definitions, contracts, generated code
- **Business Logic**: Services, handlers, controllers
- **Frontend**: Components, hooks, pages, state management
- **Tests**: Unit tests, integration tests

For each layer, the research phase will discover:
- Where similar files live in this repository
- What patterns and conventions to follow
- What code generation steps are needed

## Dependencies

### Stack Versions
Reference exact versions from Project Context (discovered by `/start_work`):
- **Language**: [e.g., Go 1.22, TypeScript 5.3]
- **Key frameworks**: [e.g., React 18.2, Next.js 14.1, Django 5.0]
- **Runtime**: [e.g., Node 20.11, Python 3.12]

Use version-specific APIs and patterns. If a version-specific feature is required, note it explicitly.

### Internal Dependencies
- [Discover from codebase - what existing code does this feature depend on?]

### External Dependencies
- [List any new external services, libraries, or packages needed]

## Out of Scope
Explicitly state what this feature does NOT include:
- Advanced filtering/sorting (future enhancement)
- Bulk operations (future enhancement)
- Export/import functionality (future enhancement)

## Open Questions
List anything that needs clarification before implementation:
1. Should entity names be unique per user or globally?
2. What is the maximum length for entity names?
3. Do we need soft delete or hard delete?

## Success Metrics
How we measure if this feature is successful:
- Users can create entities in < 500ms
- Entity creation success rate > 99.5%
- Zero security vulnerabilities
- All acceptance criteria met
- Test coverage > 80%

## Requirements Traceability

| Requirement ID | Description | Test ID(s) | Status |
|---|---|---|---|
| REQ-1 | [summary from requirement] | (assigned during /generate_tests) | Pending |
| REQ-2 | [summary] | (assigned during /generate_tests) | Pending |
| EDGE-1 | [summary] | (assigned during /generate_tests) | Pending |
| ERR-1 | [summary] | (assigned during /generate_tests) | Pending |

**Status values:** Pending | Tested | Verified | N/A

- **Pending**: Requirement defined, no tests yet
- **Tested**: Test(s) written and assigned (during `/generate_tests`)
- **Verified**: Test(s) pass against implementation (during `/implement`)
- **N/A**: Requirement not applicable (must be approved by user)

## Testing Strategy

### Unit Tests
Discover test framework and patterns from existing tests in the repository.
- Business logic / service functions
- Data access / query functions
- UI components (if applicable)
- Utility functions and helpers

### Integration Tests
- End-to-end API flow
- Database transaction integrity
- Cross-layer integration

### Manual Testing Checklist
- [ ] Create entity with valid input
- [ ] Create entity with invalid input
- [ ] Create entity without authentication
- [ ] Create entity without authorization
- [ ] View entity list
- [ ] View individual entity
- [ ] Update entity
- [ ] Delete entity
- [ ] Test error messages are user-friendly
- [ ] Test keyboard navigation
- [ ] Test screen reader compatibility

## References
- Existing patterns: [discover similar implementations in the codebase]
- Design mockups: [link if available]
- Related tickets: [TICKET-ID]
- API documentation: [link if available]

## Spec Summary

> **Only generate this section if the spec exceeds 200 lines.**
> Later phases can read the summary first, then selectively load relevant sections to stay within context budget.

**Feature**: [1-2 sentence summary of what this feature does and why]

**Requirements Overview**:

| ID | Summary | Priority |
|---|---|---|
| REQ-1 | [brief summary] | Must have |
| REQ-2 | [brief summary] | Must have |
| EDGE-1 | [brief summary] | Should have |
| ERR-1 | [brief summary] | Must have |

**Key API Endpoints**: [list endpoints if applicable]

**Key Data Models**: [list models if applicable]

**Top Constraints**:
- [constraint 1]
- [constraint 2]
- [constraint 3]

---

## Next Phase
After specification is approved:
1. Save to `ai-context/specs/[date]_[ticket]_[feature]_spec.md`
2. Clear context
3. Proceed to `/generate_tests` phase
```

## Usage Example

```
User: /create_spec Add entity management with CRUD operations for admin users

AI: [Proceeds to Phase 1: Gather Requirements]
AI: [Asks clarifying questions...]
AI: [Generates specification in Phase 2]
```

## Presenting the Specification for Approval

**CRITICAL: After creating the specification in plan mode, you must present it for user approval using AskUserQuestion (NOT ExitPlanMode).**

### Step 1: Write the Specification File

While in plan mode, write your specification to the designated file:
- Use Write tool to create: `ai-context/specs/[date]_[ticket]_[feature]_spec.md`
- Filename format: `ai-context/specs/[date]_[ticket]_[feature]_spec.md`
- Example: `ai-context/specs/2025-01-15_PROJ-123_entity-management_spec.md`

### Step 2: Present Specification for Approval (Using AskUserQuestion, NOT ExitPlanMode)

**Do NOT use ExitPlanMode** — it presents default options including "Clear context and implement plan" which breaks the orchestrator's ability to route to the next TDD phase.

Instead, present a summary of the specification to the user, then use **AskUserQuestion** to get approval:

- **Question**: "Does this specification look correct?"
- **Options**:
  1. "Yes, approve specification (Recommended)" — Mark spec as approved
  2. "No, I have feedback" — Collect revision notes and update the spec
  3. "Let me review the saved file first" — Point to the file path and wait

**If approved (option 1):** Continue to Step 3 (commit) and Step 4 (update status), then present the Phase Complete message.
**If feedback (option 2):** Incorporate changes, update the spec file, and ask again.
**If reviewing (option 3):** Provide the file path and wait for the user to respond.

### Step 3: After Approval - Commit the Specification

Once the user approves the specification:

```bash
git add ai-context/specs/[date]_[ticket]_[feature]_spec.md
git commit -m "[commit message following project conventions, e.g., docs(core): add specification for [feature]]"
```

### Step 4: Update Status

- Update `ai-context/current-work.md` to mark Spec Phase as complete
- Update specification status from "Draft" to "Approved"

### Step 5: Phase Complete

After the specification is approved, committed, and status updated, present:

```
✅ Specification Complete!

Saved to: ai-context/specs/[date]_[ticket]_[feature]_spec.md
Status: Approved

CONTEXT ISOLATION — run /clear before continuing.
The test writer must work from the spec document alone,
not from the spec author's reasoning.

Next command (after /clear):
  /generate_tests @ai-context/specs/[date]_[ticket]_[feature]_spec.md
```

**Do NOT invoke the Skill tool or offer to auto-run the next phase.** Context isolation requires a fresh context for test generation.

## Context Management

### Keeping Context Low
- Start with minimal context (20-25%)
- Ask focused questions
- Don't load entire codebase
- Reference existing patterns by file path only

### After Completion
- Save specification to `ai-context/specs/`
- **Clear context completely** before next phase
- Next phase will reference spec with `@ai-context/specs/[file].md`

## Quality Checklist

Before proceeding to test generation, verify:
- ✅ All requirements have clear acceptance criteria
- ✅ Edge cases are documented
- ✅ Error scenarios are specified
- ✅ API contracts are defined
- ✅ Data models are specified
- ✅ Dependencies are identified
- ✅ Success metrics are measurable
- ✅ Out of scope items are clear
- ✅ Implementation layers are identified
- ✅ Specification is testable (can generate tests from it)

## Tips for Better Specifications

1. **Be specific**: "Response time < 200ms" not "fast response"
2. **Be testable**: Every requirement should have clear acceptance criteria
3. **Be complete**: Cover happy path, edge cases, and error scenarios
4. **Be realistic**: Don't specify impossible requirements
5. **Be focused**: One feature at a time, not multiple features
6. **Use examples**: Show concrete examples of inputs/outputs
7. **Reference patterns**: Point to similar existing code in the repo
8. **Consider layers**: Think through backend, frontend, database, and API

## Common Mistakes to Avoid

- ❌ Vague requirements ("should be user-friendly")
- ❌ Missing error scenarios
- ❌ No acceptance criteria
- ❌ Unclear data models
- ❌ Unspecified API contracts
- ❌ No performance requirements
- ❌ Ignoring security considerations
- ❌ Not identifying dependencies
- ❌ Skipping the question phase (jumping to spec too early)

## Example: Good vs. Bad Requirements

### Bad Requirement
"Users should be able to create entities"

### Good Requirement
**REQ-1**: Create Entity via API
- **Input**:
  - `name` (string, 1-100 characters, required)
  - `description` (string, 0-500 characters, optional)
- **Process**:
  - Validate user is authenticated
  - Validate input per project validation conventions
  - Create entity in database with generated UUID
  - Set owner to current user
  - Set timestamps to current time
- **Output**:
  - `EntityResponse` with id, name, description, created_at, updated_at
- **Acceptance Criteria**:
  - [ ] Returns 200 OK with EntityResponse on success
  - [ ] Returns 401 Unauthenticated if no auth token
  - [ ] Returns 400 InvalidArgument if name is empty
  - [ ] Returns 400 InvalidArgument if name > 100 characters
  - [ ] Entity is persisted in database
  - [ ] Owner is set to current user
  - [ ] Timestamps are set to current time (within 1 second)

## Workflow Position

This is **Phase 1** of the Test-First AI Development Workflow:

1. **Spec Phase** ← You are here
   - Phase 0: Extract from URL (if applicable)
   - Phase 1: Gather requirements
   - Phase 2: Create specification
2. Test Phase (`/generate_tests`)
3. Research Phase (`/research_implementation`)
4. Implement Phase (`/implement`)
5. Refine Phase (`/refactor`)

After completing the specification, clear context and proceed to `/generate_tests`.

## Summary

**Input Format**:
- ✅ Plain text requirements only

**Workflow**:
1. Provide plain text requirements to `/create_spec [requirements]`
2. AI asks clarifying questions (Phase 1)
3. AI generates comprehensive specification (Phase 2)
4. Specification is saved to `ai-context/specs/` directory

**Benefits**:
- Clear, focused requirements gathering
- Structured specification output
- Testable acceptance criteria
- Foundation for test-first development
