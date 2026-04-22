# Claude Code Global Standards + Archive Workflow

A set of global configuration files for Claude Code that enforce production-grade, enterprise-level code quality across every project — plus a lightweight file archive script to preserve originals before modifying them.

Built for developers who ship real software to real users and need Claude Code to behave accordingly.

---

## What's Included

```
├── CLAUDE.md                  # Global Claude Code standards — goes in ~/.claude/
├── rules/
│   ├── security.md            # Security rules — goes in ~/.claude/rules/
│   ├── testing.md             # Testing standards — goes in ~/.claude/rules/
│   └── patterns.md            # Code patterns — goes in ~/.claude/rules/
└── archive.sh                 # File archive script — goes in ~/bin/
```

---

## What It Does

### Global Claude Code Standards

Every Claude Code session on your machine automatically loads these rules. Claude will:

- Never write pseudocode, placeholders, or stubs
- Never delete or comment out code to fix errors
- Never suppress errors to make something pass
- Never overwrite a file without archiving it first
- Write production-ready code only — no tutorial shortcuts
- Enforce proper error handling, typed returns, input validation
- Follow security best practices on every file it touches
- Write real tests covering happy path, error paths, and edge cases

### archive.sh

Before modifying any file, run `archive.sh <filepath>`. It:

- Copies the original file to your archive directory
- Organises by project name and month-year automatically
- Preserves the file's full relative path structure
- Works from anywhere inside a git repo
- Never touches the repo itself — archive lives outside

---

## Installation

### 1. Clone the repo

```bash
git clone https://github.com/yourusername/claude-code-standards.git
cd claude-code-standards
```

### 2. Install the global Claude Code files

```bash
# Create the directories if they don't exist
mkdir -p ~/.claude/rules

# Copy the global CLAUDE.md
cp CLAUDE.md ~/.claude/CLAUDE.md

# Copy the rules files
cp rules/security.md ~/.claude/rules/security.md
cp rules/testing.md ~/.claude/rules/testing.md
cp rules/patterns.md ~/.claude/rules/patterns.md
```

### 3. Install the archive script

```bash
# Create ~/bin if it doesn't exist
mkdir -p ~/bin

# Copy and make executable
cp archive.sh ~/bin/archive.sh
chmod +x ~/bin/archive.sh
```

### 4. Add ~/bin to your PATH

Add the following to your `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="$HOME/bin:$PATH"
```

Then reload your shell:

```bash
source ~/.bashrc
# or
source ~/.zshrc
```

### 5. Configure your archive location (optional)

By default the script archives to `~/codebase-archive/`. To use a different location, add this to your `~/.bashrc` or `~/.zshrc`:

```bash
export CODEBASE_ARCHIVE_DIR="$HOME/Documents/codebase-archive"
```

Then reload:

```bash
source ~/.bashrc
```

---

## Usage

### archive.sh

Run from inside your repo before modifying any file:

```bash
archive.sh <filepath>
```

**Examples:**

```bash
# Archive a single file
archive.sh src/lib/auth/session.ts

# Archive a config file before restructuring it
archive.sh prisma/schema.prisma

# Archive from a subdirectory
archive.sh components/dashboard/CaseCard.tsx
```

**Output:**

```
Archived: src/lib/auth/session.ts
       -> /home/youruser/codebase-archive/myproject/april 2026/src/lib/auth/session.ts
```

**Archive structure:**

```
~/codebase-archive/
└── myproject/
    └── april 2026/
        └── src/
            └── lib/
                └── auth/
                    └── session.ts
```

---

### Claude Code

Once the files are in place, Claude Code picks them up automatically. No additional setup needed.

Open any project in Claude Code and the global standards are active. You should see Claude acknowledge the rules at the start of sessions where they're relevant.

To verify it's loading:

```bash
# Start a Claude Code session and ask:
# "What are your coding standards for this session?"
claude
```

---

## Project-Level Compliance (Optional)

For projects with specific compliance requirements (law enforcement integrations, federal contracts, healthcare data etc.), add a project-level rules file:

```bash
mkdir -p /your/repo/.claude/rules
touch /your/repo/.claude/rules/compliance.md
```

Project-level rules stack on top of the global rules. Claude Code loads both.

A compliance template for platforms serving law enforcement under CJIS Security Policy v6.0 is available in the `examples/` folder.

---

## Customising the Standards

Edit any of the files in `~/.claude/` to match your preferences. Key sections in `CLAUDE.md`:

- **The Non-Negotiables** — hard rules Claude never breaks
- **Code Quality Standard** — the bar every file must meet
- **Security — Always On** — security rules applied to every project
- **What I Expect From You** — how Claude handles ambiguity and tradeoffs
- **What I Do Not Want** — what to suppress (sycophancy, over-engineering etc.)

---

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) installed
- Bash (Linux / macOS)
- Git (for project name detection in `archive.sh`)
- `realpath` (standard on Linux, install via `brew install coreutils` on macOS)

---

## macOS Notes

`realpath` is not included by default on macOS. Install it:

```bash
brew install coreutils
```

---

## License

MIT — use it, fork it, modify it.

---

## Contributing

If you add rules that meaningfully improve Claude Code output in production environments, PRs are welcome. Keep rules specific, enforceable, and free of vague guidance.
