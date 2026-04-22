# Global Testing Rules

No pseudocode tests. No tests that only test happy path. No merging with red tests.

---

## Coverage Expectations

| Code Type | Minimum Coverage |
|---|---|
| Auth and crypto | 100% |
| Business logic | 80% |
| API endpoints | 100% of routes |
| Utility functions | 80% |
| UI components | Key interactions |

Coverage numbers are a floor, not a goal. A test that doesn't assert anything meaningful doesn't count.

---

## What Every Test Must Do

- Test one thing — single responsibility per test
- Have a descriptive name that explains what it's testing and what the expected outcome is
- Be deterministic — same result every run, no flakiness tolerated
- Clean up after itself — no shared state between tests
- Run fast — unit tests under 100ms each

## Structure

```
describe("ComponentOrFunction", () => {
  describe("methodOrBehavior", () => {
    it("returns X when given Y", () => { ... })
    it("throws when input is invalid", () => { ... })
    it("denies access when user lacks permission", () => { ... })
  })
})
```

Name pattern: `it("[does something] when [condition]")`

---

## What To Test

### Happy Path
The expected success case with valid input and correct permissions.

### Error Paths — Required for Every Function
- Invalid input (wrong type, missing required fields, out of range)
- Unauthorized access (wrong role, expired session, missing token)
- External service failure (mock the failure, verify graceful handling)
- Database errors (mock failure, verify no data corruption)
- Edge cases (empty arrays, null values, maximum lengths, concurrent writes)

### Security-Specific Tests — Required on Auth and Data Endpoints
- Unauthenticated request returns 401
- Authenticated but unauthorized request returns 403
- Injection attempts are rejected (SQL, XSS, path traversal)
- Rate limiting triggers correctly
- Token expiry is enforced
- Role escalation is not possible

---

## Mocking Rules

- Mock all external services — no live API calls in tests
- Mock at the boundary — mock the HTTP client or DB client, not internal functions
- Use realistic mock data — not `"test"` and `123`, use actual valid-format data
- Never mock the thing you're testing
- Document why a mock is needed if it's not obvious

---

## Test Data

- Never use production data in tests
- Generate realistic synthetic data
- Use factories or fixtures — not hardcoded values scattered across test files
- Sensitive-looking test data (emails, names, IDs) should be obviously fake

---

## CI Requirements

- All tests run on every PR
- Build fails on any test failure
- Build fails on coverage drop below thresholds
- Build fails on `npm audit` high/critical vulnerabilities
- No merging with skipped tests unless documented exception exists

---

## What Not To Do

- Don't test implementation details — test behavior and outcomes
- Don't write tests after the fact to hit a coverage number
- Don't use `it.skip` without a linked issue explaining why
- Don't duplicate test logic — use helpers and factories
- Don't write tests that pass regardless of what the code does
