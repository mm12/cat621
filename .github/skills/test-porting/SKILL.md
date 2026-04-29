---
name: test-porting
description: "Use when porting shoulda tests to rspec, resolving test changes while merging master, reviewing test diffs from main, or converting existing test updates into the repo's RSpec style."
argument-hint: "Helper for test porting"
---

# Test Porting

## When to Use
- Porting changed or added tests from shoulda to RSpec.
- Reconciling a branch with upstream master while keeping the branch's test changes.
- Reviewing the current branch's test-only delta against main.
- Cleaning up merged test conflicts so they match the repo's RSpec conventions.

## Core Goal
Preserve the intent of the branch's test changes while rewriting them in the project's RSpec style. Treat `master` as the source of newly merged upstream tests and `main` as the baseline for identifying the branch's test edits.

## Workflow
1. Inspect the branch delta against `main` to find the changed or added tests that still need porting.
2. Review nearby specs and `spec/README.md` for the local pattern before editing anything.
3. Compare the branch's test changes with the equivalent upstream test area from `master` so you can keep the right behavior and drop obsolete shoulda patterns.
4. Port the test in the smallest possible slice.
5. Prefer existing spec helpers, shared contexts, and factories over inventing new setup.
6. Run the narrowest CLI test command that covers the touched spec file or directory.
7. Fix failures locally, then rerun the same narrow command until it passes.
8. Run RuboCop on the touched spec path if the change introduces new style risk.

## Decision Points
- If a test exists on `master`, keep the upstream behavior and rewrite the branch-specific assertion style to RSpec.
- If a test only exists on the branch, preserve its intent and translate the shoulda coverage into the closest RSpec example group structure.
- If a conflict mixes upstream test changes and branch-specific test edits, resolve the upstream side first, then reapply the branch intent in RSpec form.
- If the correct setup is unclear, search for the nearest existing spec with the same concern and copy its structure.

## Porting Rules
- Translate shoulda matchers and macros into explicit examples and expectations.
- Prefer `describe` and `context` blocks that mirror behavior boundaries rather than matcher-driven one-liners.
- Use factories and shared contexts already established in the repo.
- Avoid `type: :model` or other redundant spec metadata when the path already infers it.
- Keep assertions focused on one behavior per example unless the existing pattern clearly groups related outcomes.

## Validation Loop
- Use CLI test commands, not VS Code tasks, so runs can take advantage of parallel execution.
- Start with the smallest practical spec file or directory command.
- If the file passes, expand only if adjacent specs were also touched.
- After a passing test run, check whether RuboCop or a second targeted spec run is still needed for the edited slice.

## Completion Checks
- The branch-specific test changes are expressed in RSpec style.
- The touched specs pass locally with the narrow CLI test command.
- RuboCop is clean for the touched spec slice, or any remaining issue is clearly unrelated.
- The resulting examples match the repo conventions in `spec/README.md`.

## Helpful References
- Consult `spec/README.md` for repo-specific RSpec conventions.
- Use `git diff main` to identify the branch's current test changes.
- Use `git merge master` as the upstream reconciliation model when resolving test conflicts.
