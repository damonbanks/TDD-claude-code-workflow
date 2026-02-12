# Project Discovery Protocol

**This is a reference document, not a slash command.** All workflow commands follow this protocol to auto-detect project characteristics at runtime.

---

## Purpose

Every project is different: different languages, ticket systems, git platforms, commit conventions, and tooling. This protocol defines how commands discover these details automatically so the TDD workflow works in any codebase without manual configuration.

---

## 1. Ticket Detection

### Auto-Detect from Branch Name

Extract ticket ID from the current branch using common patterns:

| Pattern | Example | System |
|---------|---------|--------|
| `[A-Z]+-\d+` | `PROJ-123`, `JIRA-456` | Jira, Linear, YouTrack |
| `#\d+` | `#42` | GitHub/GitLab issues |
| `sc-\d+` | `sc-12345` | Shortcut (formerly Clubhouse) |
| `\d{4,}` | `12345` | Generic numeric IDs |

```bash
# Extract from branch name
git branch --show-current
# e.g., feat/PROJ-123-add-auth → ticket is PROJ-123
# e.g., fix/42-login-bug → ticket is #42
```

### Fallback: Check Git Log

```bash
git log --oneline -5
# Look for ticket references in recent commit messages
```

### Fallback: Ask the User

If no ticket is detected, ask using AskUserQuestion:
- "Do you have a ticket ID for this work?"
- Options:
  1. "Yes, I'll provide it" — accept any format
  2. "No ticket" — proceed without one

### Ticket is Optional

Not all projects use ticket systems. If the user says "no ticket," proceed without one. Omit the `TICKET-ID` portion from artifact filenames and commit messages.

**Artifact filename without ticket:** `YYYY-MM-DD_feature-name_type.md`
**Artifact filename with ticket:** `YYYY-MM-DD_TICKET-ID_feature-name_type.md`

---

## 2. Language Detection

Check for language-specific manifest files in the project root (and common subdirectories):

| File | Language/Platform |
|------|-------------------|
| `go.mod` | Go |
| `package.json` | JavaScript/TypeScript (check for `tsconfig.json` too) |
| `Cargo.toml` | Rust |
| `pyproject.toml`, `setup.py`, `requirements.txt` | Python |
| `pom.xml`, `build.gradle`, `build.gradle.kts` | Java/Kotlin |
| `*.csproj`, `*.sln` | C# / .NET |
| `Gemfile` | Ruby |
| `composer.json` | PHP |
| `mix.exs` | Elixir |
| `Package.swift` | Swift |
| `CMakeLists.txt` | C/C++ |
| `deno.json` | Deno |

**Multi-language projects:** Many repos contain multiple languages (e.g., Go backend + TypeScript frontend). Detect all and note which parts of the codebase use which language.

---

## 3. Test Conventions

### Discover from Existing Tests

```bash
# Find test files
Glob: **/*_test.*
Glob: **/*.test.*
Glob: **/*.spec.*
```

From existing test files, determine:
- **Framework**: What test runner and assertion library (e.g., Jest, pytest, go test, RSpec, JUnit, Cargo test)
- **Location**: Colocated with source or in separate `test/` / `tests/` / `__tests__` directories
- **Naming**: `*_test.go`, `*.test.ts`, `*.spec.rb`, `test_*.py`, etc.
- **Style**: How are tests structured (describe/it, Test functions, test classes, etc.)
- **Fixtures/mocks**: What patterns for test data and mocking

### Read a Few Test Files

Read 2-3 existing test files to understand:
- Import structure and assertion style
- Setup/teardown patterns
- Mock and fixture patterns
- Helper utilities

---

## 4. Git Platform

### Detect from Remote URL

```bash
git remote get-url origin
```

| URL Contains | Platform |
|-------------|----------|
| `github.com` | GitHub |
| `gitlab.com` or self-hosted GitLab | GitLab |
| `bitbucket.org` | Bitbucket |
| `dev.azure.com` | Azure DevOps |

### Detect from CI/CD Config

| File/Directory | Platform |
|---------------|----------|
| `.github/` or `.github/workflows/` | GitHub |
| `.gitlab-ci.yml` | GitLab |
| `bitbucket-pipelines.yml` | Bitbucket |
| `azure-pipelines.yml` | Azure DevOps |
| `Jenkinsfile` | Jenkins |
| `.circleci/` | CircleCI |

### Platform-Specific Commands

| Action | GitHub | GitLab | Bitbucket |
|--------|--------|--------|-----------|
| Create PR/MR | `gh pr create` | `glab mr create` | Manual or `bb` CLI |
| List PRs/MRs | `gh pr list` | `glab mr list` | Manual |
| Check CI | `gh pr checks` | `glab ci status` | Manual |

**If platform is unknown or no CLI available:** Instruct the user to create the PR/MR through their platform's web interface.

---

## 5. Commit Conventions

### Detect from Git History

```bash
git log --oneline -20
```

Look for patterns:
- **Conventional Commits**: `type(scope): description` (e.g., `feat(auth): add login`)
- **Ticket-prefixed**: `PROJ-123: description`
- **Simple**: Just a description
- **Emoji-prefixed**: `:sparkles: add feature`

### Check for Config

Look for commitlint or similar configuration:
- `.commitlintrc`, `.commitlintrc.yml`, `.commitlintrc.json`
- `commitlint.config.js`, `commitlint.config.ts`
- `package.json` → `"commitlint"` key
- `.czrc`, `.cz.json` (Commitizen)

### Follow the Project's Convention

Use whatever pattern the project already uses. If no clear pattern exists, default to Conventional Commits: `type(scope): description`

---

## 6. Build/Test/Lint Commands

### Discovery Order

Check these sources in order for test, build, and lint commands:

1. **`Makefile`** — Look for targets: `test`, `lint`, `build`, `format`, `generate`
2. **`package.json`** — Look in `"scripts"`: `test`, `lint`, `build`, `format`, `typecheck`
3. **`Cargo.toml`** / `pyproject.toml` — Look for tool-specific config sections
4. **CI config** (`.github/workflows/*.yml`, `.gitlab-ci.yml`) — Look for actual commands used
5. **`README.md`** — Look for development/build instructions
6. **`AGENTS.md`** / `CLAUDE.md`  / `CONTRIBUTING.md` — Look for development setup instructions

### Common Patterns by Language

| Language | Test | Lint | Format |
|----------|------|------|--------|
| Go | `go test ./...` | Check Makefile | Check Makefile |
| JS/TS (npm) | `npm test` | `npm run lint` | `npm run format` |
| JS/TS (pnpm) | `pnpm test` | `pnpm lint` | `pnpm format` |
| Rust | `cargo test` | `cargo clippy` | `cargo fmt` |
| Python | `pytest` | `ruff check .` | `ruff format .` |
| Java (Maven) | `mvn test` | Check config | Check config |
| Java (Gradle) | `./gradlew test` | Check config | Check config |
| Ruby | `bundle exec rspec` | `bundle exec rubocop` | Check config |
| C# | `dotnet test` | Check config | `dotnet format` |
| Elixir | `mix test` | `mix credo` | `mix format` |

**Always prefer the project's actual commands over these defaults.** The Makefile or CI config is the source of truth.

---

## 7. Optional Configuration Override

If the file `ai-context/.workflow-config.yml` exists, read it and use its values to override auto-detection. See `.workflow-config.yml.template` for the format.

Auto-detection works without this file. The config is for projects that want explicit control.

---

## Usage by Commands

### `/start_work` (the entry point)

`/start_work` runs this full discovery protocol and writes the results to `ai-context/current-work.md` under a `## Project Context` section:

```markdown
## Project Context
- **Language(s)**: [e.g., Go, TypeScript]
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

### All other commands

Every other command (`/create_spec`, `/generate_tests`, `/research_implementation`, `/implement`, `/refactor`, `/finish_work`) should:

1. **Read `ai-context/current-work.md`** at the start and use the cached `## Project Context` values
2. **If no Project Context exists** (e.g., user ran the command directly without `/start_work`), run this discovery protocol and cache the results
3. **Use discovered values** for:
   - Test commands (don't hardcode `go test` or `npm test`)
   - Lint/format commands (don't hardcode specific tools)
   - Commit message format (follow the project's convention)
   - PR/MR creation (use the right platform tool)
   - Ticket references (use whatever format the project uses, or omit)
   - Code patterns (follow what exists in the repo)
