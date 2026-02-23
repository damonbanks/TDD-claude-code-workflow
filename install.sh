#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
TAG="${1:-}"

echo "Installing TDD Claude Code Workflow..."
echo "  Source: ${REPO_DIR}"
echo "  Target: ${CLAUDE_DIR}"

# Checkout requested tag or pull latest main
git -C "${REPO_DIR}" fetch --tags
if [ -n "${TAG}" ]; then
  echo "  Version: ${TAG}"
  git -C "${REPO_DIR}" checkout "${TAG}"
else
  echo "  Version: latest (main)"
  git -C "${REPO_DIR}" checkout main
  git -C "${REPO_DIR}" pull
fi

# Ensure ~/.claude exists
mkdir -p "${CLAUDE_DIR}"

# Remove existing commands (files or symlink) and replace with symlink
rm -rf "${CLAUDE_DIR}/commands"
ln -s "${REPO_DIR}/commands" "${CLAUDE_DIR}/commands"

echo ""
echo "Done. Commands are now symlinked."
