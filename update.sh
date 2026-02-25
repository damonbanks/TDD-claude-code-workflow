#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TAG="${1:-}"

echo "Updating TDD Claude Code Workflow..."

git -C "${REPO_DIR}" fetch --tags
if [ -n "${TAG}" ]; then
  echo "  Version: ${TAG}"
  git -C "${REPO_DIR}" checkout "${TAG}"
else
  echo "  Version: latest (main)"
  git -C "${REPO_DIR}" checkout main
  git -C "${REPO_DIR}" pull
fi

# Re-link command files (picks up any new files added since install)
CLAUDE_DIR="${HOME}/.claude"
if [ -L "${CLAUDE_DIR}/commands" ]; then
  echo "  Replacing old directory symlink with per-file symlinks..."
  rm "${CLAUDE_DIR}/commands"
fi
mkdir -p "${CLAUDE_DIR}/commands"

echo "  Linking command files:"
for file in "${REPO_DIR}/commands/"*; do
  filename="$(basename "$file")"
  ln -sf "$file" "${CLAUDE_DIR}/commands/${filename}"
  echo "    ${filename} -> ${file}"
done

echo ""
echo "Done. Command files are now symlinked."
