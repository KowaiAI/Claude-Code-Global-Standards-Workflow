# Global Code Patterns

Preferred patterns across all projects. Deviate only with documented reason.

---

## TypeScript

- Strict mode always — `"strict": true` in tsconfig
- Explicit return types on all functions
- No `any` — use `unknown` and narrow, or define the type properly
- Prefer `interface` for object shapes, `type` for unions and computed types
- Use discriminated unions for state that has multiple valid shapes
- Enums for fixed sets of values — not string literals scattered across files
- Zod or equivalent for runtime validation of external data (API responses, user input)

```typescript
// Never
async function getUser(id: any): Promise<any> { ... }

// Always
async function getUser(id: string): Promise<User | null> { ... }
```

---

## Error Handling

- Every async operation has explicit error handling
- Never swallow errors silently
- Return typed errors where possible — don't just throw strings
- Use Result types or explicit error returns for expected failure cases
- Reserve thrown exceptions for truly unexpected failures

```typescript
// Never
try {
  await doThing()
} catch (e) {
  console.log(e)
}

// Always
try {
  await doThing()
} catch (error) {
  logger.error("doThing failed", { error, context: { userId, resourceId } })
  throw new AppError("OPERATION_FAILED", "Failed to complete operation", { cause: error })
}
```

---

## API Endpoints

Standard structure for every endpoint:

1. Authenticate (verify token/session)
2. Authorize (verify role/permission for this resource)
3. Validate input (schema validation)
4. Execute business logic
5. Audit log the action
6. Return typed response

Never skip steps. Never reorder them.

```typescript
export async function handler(req: Request): Promise<Response> {
  // 1. Auth
  const session = await getSession(req)
  if (!session) return unauthorized()

  // 2. Authorize
  if (!hasPermission(session.user, "cases:read")) return forbidden()

  // 3. Validate
  const input = CaseQuerySchema.safeParse(req.query)
  if (!input.success) return badRequest(input.error)

  // 4. Business logic
  const cases = await caseService.query(input.data, session.user)

  // 5. Audit
  await audit.log({ userId: session.user.id, action: "READ", resource: "Case" })

  // 6. Response
  return ok(cases)
}
```

---

## Database

- Parameterized queries only — ORM or raw parameterized, never string interpolation
- Transactions for any operation that touches multiple tables
- Never `SELECT *` — always specify columns
- Index foreign keys and columns used in WHERE clauses
- Soft deletes on sensitive data — keep audit trail
- Migrations are versioned, forward-only, and tested before deploying

---

## Logging

Use structured logging — object-based, not string concatenation:

```typescript
// Never
console.log("User " + userId + " accessed case " + caseId)

// Always
logger.info("Case accessed", { userId, caseId, tier: user.accountTier })
```

Log levels:
- `error` — something broke, needs attention
- `warn` — something unexpected but handled
- `info` — significant business events (login, case creation, export)
- `debug` — development only, never in production builds

Never log: passwords, tokens, full PII, API keys, session identifiers.

---

## Environment Config

- All config from environment variables — never hardcoded
- Validate required env vars at startup — fail fast if missing
- Use a config module that validates and types env vars (e.g. `zod` schema on `process.env`)
- Separate config for: development, test, staging, production
- Never commit `.env` files — only `.env.example` with dummy values

---

## File and Module Organization

- One primary export per file
- File name matches the primary export name
- Group by feature, not by type — `src/cases/` not `src/controllers/`
- Shared utilities in `src/lib/`
- Types co-located with the code that uses them, or in `src/types/` if shared
- No circular dependencies

---

## Git

- Conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `test:`, `refactor:`
- One logical change per commit
- PR description explains what changed and why, not just what
- No force pushing to main or shared branches
- Feature branches off main, merged via PR with review
