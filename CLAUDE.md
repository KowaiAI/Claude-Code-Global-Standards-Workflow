# Global Claude Code Standards — Kowai

## Who I Am

Solo operator building production-grade civic tech and investigative infrastructure.
Projects include platforms that will be used by law enforcement, journalists, and the public.
Code quality is non-negotiable. Assume everything ships to production.

---

## The Non-Negotiables

- **No pseudocode.** Ever. Write the real implementation or tell me it needs more information.
- **No placeholders.** No `// TODO`, no `// implement this later`, no stub functions left empty.
- **No tutorial-level code.** No hardcoded example values, no `foo`/`bar`, no demo shortcuts.
- **No "this works for now" patterns.** If it's not production-ready, don't write it.
- **No assumptions about environment.** Ask if you need to know something about infra, config, or context.
- **Never delete files to resolve errors.** Deletion is not a fix. Find the root cause and fix it properly.
- **Never comment out code to suppress errors.** Commented-out code is not a solution. If code is wrong, fix it or remove it entirely with a documented reason. If it's temporarily disabled, that requires an explicit explanation and a tracked issue — not a silent comment block.
- **Never suppress, ignore, or swallow errors to make something pass.** No `try/catch` with empty catch blocks, no `// eslint-disable`, no `@ts-ignore` without a documented reason directly above it explaining why it's acceptable.
- **Never overwrite or delete a file without archiving it first.** Before modifying any file significantly or replacing it entirely, copy the original to `~/Documents/codebase-archive/[project]/[month-year]/` first. Run `archive.sh [filepath]` before making changes. The archive lives outside the repo — git and Claude Code never see it.

---

## Code Quality Standard

Write code as if it will be:
- Audited by a federal security assessor
- Read by a senior engineer who will reject it if it's sloppy
- Running in production handling real user data tomorrow

That means:
- Proper error handling on every async operation — no silent failures
- Explicit return types on all functions (TypeScript)
- Input validation before any data touches business logic
- No `any` types in TypeScript unless absolutely unavoidable and documented why
- No `console.log` left in production code paths — use structured logging
- No dead code — if it's not used, it's not there

---

## Security — Always On

These apply to every project, every file, every PR:

- Never log sensitive data — no PII, tokens, passwords, or keys in any log output
- Never store secrets in code — environment variables only
- Never trust user input — validate type, length, format, and content server-side
- Never use deprecated crypto — no MD5, SHA-1, DES, RC4, or ECB mode
- Always use parameterized queries — no string interpolation in SQL ever
- Always enforce authentication before authorization before data access
- Always encode output to prevent XSS
- Rate limit all public-facing endpoints
- HTTPS only — no HTTP in any production path

---

## Testing Standard

- Unit tests for all business logic — not optional
- Integration tests for all API endpoints
- Test happy path, error path, and edge cases — not just happy path
- No merging code with failing tests
- Mock external services in tests — no live API calls in test suite
- Test files live next to the code they test or in a parallel `__tests__/` structure
- Minimum coverage expectation: 80% on business logic, 100% on auth and crypto paths

---

## Architecture Principles

- **Separation of concerns** — auth logic, business logic, and data access are separate layers
- **Fail closed** — when in doubt, deny access rather than permit it
- **Least privilege** — functions and queries only access what they need
- **Explicit over implicit** — no magic, no hidden behavior
- **Stateless where possible** — design APIs to be stateless
- **Idempotent operations** — especially for writes and external calls

---

## What I Expect From You

- If the requirements are unclear, ask before writing code
- If there are multiple valid approaches, present the tradeoffs briefly then recommend one
- If something I've asked for is a bad idea, tell me before doing it
- If you hit a limitation mid-task, stop and tell me rather than shipping something incomplete
- If a file is getting too large or complex, flag it and suggest a refactor path

---

## What I Do Not Want

- Sycophantic responses — skip the praise, get to the work
- Excessive inline comments explaining obvious code
- Redundant abstractions added "for flexibility"
- Over-engineered solutions to simple problems
- Suggestions to "consider adding X later" — either add it or don't mention it

---

## Reference

Global security rules: `~/.claude/rules/security.md`
Global testing rules: `~/.claude/rules/testing.md`
Global patterns: `~/.claude/rules/patterns.md`
