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

# Ensure ~/.claude/commands exists as a real directory
# If it's a symlink (from a previous install), replace with a real directory
if [ -L "${CLAUDE_DIR}/commands" ]; then
  echo "  Replacing old directory symlink with per-file symlinks..."
  rm "${CLAUDE_DIR}/commands"
fi
mkdir -p "${CLAUDE_DIR}/commands"

# Symlink each command file individually, preserving any non-project files
echo "  Linking command files:"
for file in "${REPO_DIR}/commands/"*; do
  filename="$(basename "$file")"
  ln -sf "$file" "${CLAUDE_DIR}/commands/${filename}"
  echo "    ${filename} -> ${file}"
done

echo ""
echo "Done. Command files are now symlinked."
