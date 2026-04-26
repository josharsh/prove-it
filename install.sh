#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$HOME/.claude/skills/prove-it"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing prove-it skill..."

mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/skills/prove-it/SKILL.md" "$SKILL_DIR/SKILL.md"

echo "Installed to $SKILL_DIR"
echo "Restart Claude Code to activate. Use /prove-it to start."
