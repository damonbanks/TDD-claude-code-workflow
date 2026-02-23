# Finish Work Command

## Objective
Clean up AI workflow artifacts after a PR is merged (or work is abandoned), keeping the repository tidy for the next task.

## Usage
```
/finish_work
/finish_work [TICKET-ID]
```

## Project Context

**Read `ai-context/project-context.md` for cached project discovery results.** It contains the git platform and PR/MR command needed for Step 2 (verifying PR status).

## Process

### Step 1: Identify What to Clean Up

**If ticket ID is provided as argument**, use it directly.

**If no argument**, read from `ai-context/current-work.md`:
```bash
cat ai-context/current-work.md
```

**If no current-work.md exists**, ask the user:

**Use AskUserQuestion:**
- Question: "Which ticket's artifacts should I clean up?"
- Header: "Ticket"
- Options:
  1. "I'll provide the ticket ID" - User types ticket ID
  2. "Clean up all artifacts" - Remove everything (confirm first)

### Step 2: Verify PR Status

Before cleaning up, verify the work is actually done.

**Detect git platform and check PR/MR status:**

- **GitHub:** `gh pr list --head $(git branch --show-current) --state merged`
- **GitLab:** `glab mr list --source-branch $(git branch --show-current) --state merged`
- **Other/Unknown:** Ask the user directly — "Has your PR/MR been merged?"

**If PR is not merged (or status unknown):**
```
The PR for this branch may not be merged yet.

Are you sure you want to clean up artifacts?
  -> Yes - Work is abandoned or tracked elsewhere
  -> No - Keep artifacts, I'm still working
```

**If PR is merged:**
```
PR merged. Safe to clean up artifacts.
```

### Step 3: Find Artifacts for This Ticket

```bash
# Find all artifacts matching the ticket ID
find ai-context -name "*[TICKET-ID]*" -type f
```

**Show the user what will be removed:**
```
Found artifacts for [TICKET-ID]:

  ai-context/specs/[date]_[ticket]_[feature]_spec.md
  ai-context/tests/[date]_[ticket]_[feature]_tests.md
  ai-context/research/[date]_[ticket]_[feature]_research.md
  ai-context/implementation/[date]_[ticket]_[feature]_implementation.md
  ai-context/refactoring/[date]_[ticket]_[feature]_refactoring.md

Proceed with cleanup?
  -> Yes - Delete these artifacts
  -> No - Keep them
```

### Step 4: Clean Up

**Use AskUserQuestion to confirm before deleting.**

**If confirmed:**

```bash
# Remove artifacts for this ticket
find ai-context -name "*[TICKET-ID]*" -type f -delete

# Remove current-work.md if it references this ticket
rm -f ai-context/current-work.md
# NOTE: Do NOT remove project-context.md — it persists across features
```

**Present summary:**
```
Cleanup complete for [TICKET-ID].

Removed:
  - [X] artifact files
  - current-work.md

Repository is ready for the next task.
Run /start_work to begin new work.
```

### Step 5: Handle Edge Cases

**If artifacts span multiple tickets:**
Only remove artifacts matching the specified ticket ID. Leave others untouched.

**If on the feature branch that's being cleaned up:**
```
You're still on the feature branch for this ticket.

Suggested next steps:
  1. Switch to main: git checkout main && git pull
  2. Delete local branch: git branch -d [branch-name]
  3. Start new work: /start_work
```

---

## "Clean All" Option

If the user selects "Clean up all artifacts":

```bash
# List everything that would be removed
find ai-context -name "*.md" -not -name "*.template" -not -name "WORKFLOW_GUIDE.md" -not -name "README.md" -not -name "project-context.md" -not -name ".gitkeep" -type f
```

**Confirm with user before proceeding.**

**Protected files (never deleted):**
- `ai-context/WORKFLOW_GUIDE.md`
- `ai-context/README.md`
- `ai-context/project-context.md`
- `ai-context/current-work.md.template`
- `ai-context/bugs/.gitkeep`

---

## Summary

**When to use:** After a PR is merged or work is abandoned.
**What it does:** Removes workflow artifacts for a specific ticket.
**What it preserves:** Templates, guides, directory structure.
**Safety:** Always confirms with user before deleting.
