#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Updating TDD Claude Code Workflow..."
git -C "${REPO_DIR}" pull

echo ""
echo "Done."
