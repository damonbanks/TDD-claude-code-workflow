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

echo ""
echo "Done."
