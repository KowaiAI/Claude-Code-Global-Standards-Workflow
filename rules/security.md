# Global Security Rules

Applies to every project. No exceptions without explicit documented justification.

---

## Authentication

- MFA required on any account tier above basic public access
- Passwords: argon2id preferred, bcrypt minimum cost 12 — never MD5 or SHA-1
- Session tokens: 256-bit minimum entropy, cryptographically random
- Session expiry: 8 hours inactivity default, 30 minutes for privileged tiers
- Account lockout: after 5 failed attempts, require MFA or admin unlock
- Never store plaintext passwords — not even temporarily
- Never put auth logic in the client — server-side only

## Authorization

- Deny by default — no route is open unless explicitly permitted
- Check authentication first, then authorization, then return data
- Role checks happen in middleware/guard layer, not inside business logic
- Never derive permissions from user-supplied data without server-side validation
- Audit log every authorization decision on sensitive resources

## Cryptography

- Use platform crypto only: Node.js built-in `crypto`, WebCrypto API
- Do not use: `crypto-js`, `forge`, or any unvalidated third-party crypto lib for security operations
- Encryption at rest: AES-256-GCM, unique IV per operation
- Encryption in transit: TLS 1.2 minimum, TLS 1.3 preferred
- Never reuse IVs or nonces
- Key rotation: document rotation schedule in project compliance docs
- FIPS 140-3 validated modules required for any project with federal/LE users

## Input Validation

- Validate on the server — client validation is UX only, never security
- Validate: type, length, format, range, and allowed character set
- Reject and log unexpected input — do not silently strip or coerce
- File uploads: validate MIME type server-side (not just extension), scan content, enforce size limits
- Never pass raw user input to: shell commands, SQL queries, file paths, or eval

## Output

- Encode all output rendered to HTML — prevent XSS
- Set Content-Security-Policy headers on all responses
- Never reflect user input directly into responses without encoding
- API responses: never include internal stack traces, file paths, or system info in error messages

## Data Handling

- Never log: passwords, tokens, PII, API keys, or session identifiers
- Structured logging only — no freeform string concatenation with sensitive data
- Minimum data retention — only keep what you need for as long as you need it
- Secure deletion when removing sensitive records
- Separate storage for: public data, user PII, sensitive case data, audit logs

## Dependencies

- Audit dependencies before adding: `npm audit`, check CVE databases
- Pin dependency versions in production
- No abandoned packages — check last commit date and maintenance status
- Review what permissions/access a package requests before installing
- Run `npm audit` in CI — fail build on high/critical vulnerabilities

## API Security

- Rate limit all public endpoints
- Authenticate all non-public endpoints
- Never expose internal IDs directly — use opaque identifiers or UUIDs
- CORS: explicit allowlist only, never wildcard in production
- Set security headers: HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy
- Never expose stack traces or internal errors to API consumers

## Infrastructure

- No secrets in environment — use secrets manager (AWS Secrets Manager, Vault, etc.)
- No SSH keys in repos
- No API keys in code, configs, or Docker images
- Principle of least privilege on all IAM roles and service accounts
- All production changes via CI/CD — no manual console edits
