#!/bin/bash
# archive.sh — copy a file to a codebase archive before modifying it
#
# Usage: archive.sh <filepath>
# Example: archive.sh src/lib/auth/session.ts
#
# Configuration:
#   Set CODEBASE_ARCHIVE_DIR in your ~/.bashrc or ~/.zshrc to override the default.
#   Example: export CODEBASE_ARCHIVE_DIR="$HOME/Documents/codebase-archive"
#
# What it does:
#   1. Copies the file to your archive directory before you modify it
#   2. Organises by project name and month-year
#   3. Preserves the file's relative path structure inside the archive
#   4. Project name is derived automatically from the git repo name
#
# Archive structure:
#   $CODEBASE_ARCHIVE_DIR/
#   └── <project-name>/
#       └── <month year>/
#           └── <original/file/path>

set -e

# ─── Configuration ────────────────────────────────────────────────────────────
# Set CODEBASE_ARCHIVE_DIR in your shell profile to override this default.
# Default: ~/codebase-archive
ARCHIVE_ROOT="${CODEBASE_ARCHIVE_DIR:-$HOME/codebase-archive}"
# ──────────────────────────────────────────────────────────────────────────────

if [ -z "$1" ]; then
  echo "Usage: archive.sh <filepath>"
  echo ""
  echo "Set CODEBASE_ARCHIVE_DIR in your shell profile to change the archive location."
  echo "Current archive root: $ARCHIVE_ROOT"
  exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
  echo "Error: '$FILE' does not exist or is not a file."
  exit 1
fi

# Derive project name from git repo name, fall back to current directory name
PROJECT=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")

# Month-year folder (e.g. "april 2026")
MONTH_YEAR=$(date +"%B %Y" | tr '[:upper:]' '[:lower:]')

# Full archive destination
ARCHIVE_DIR="$ARCHIVE_ROOT/$PROJECT/$MONTH_YEAR"

# Preserve relative path structure inside the archive
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
RELATIVE_PATH=$(realpath --relative-to="$REPO_ROOT" "$FILE")
DEST="$ARCHIVE_DIR/$RELATIVE_PATH"

# Create destination directory
mkdir -p "$(dirname "$DEST")"

# Copy the file
cp "$FILE" "$DEST"

echo "Archived: $FILE"
echo "       -> $DEST"
