#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

echo "Installing TDD Claude Code Workflow..."
echo "  Source: ${REPO_DIR}"
echo "  Target: ${CLAUDE_DIR}"

# Ensure ~/.claude exists
mkdir -p "${CLAUDE_DIR}"

# Remove existing commands (files or symlink) and replace with symlink
rm -rf "${CLAUDE_DIR}/commands"
ln -s "${REPO_DIR}/commands" "${CLAUDE_DIR}/commands"

echo ""
echo "Done. Commands are now symlinked."
echo ""
echo "To update later:"
echo "  git -C ${REPO_DIR} pull"
