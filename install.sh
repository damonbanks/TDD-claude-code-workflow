#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="claude"
TAG=""

usage() {
  cat <<EOF
Usage: $0 [--target claude|codex] [tag]

Examples:
  $0                         # install for Claude (latest main)
  $0 v1.0.2                  # install for Claude at tag v1.0.2
  $0 --target codex          # install for Codex (latest main)
  $0 --target codex v1.0.2   # install for Codex at tag v1.0.2
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      if [ "$#" -lt 2 ]; then
        echo "Error: --target requires a value (claude|codex)"
        usage
        exit 1
      fi
      TARGET="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [ -z "${TAG}" ]; then
        TAG="$1"
        shift
      else
        echo "Error: unexpected argument: $1"
        usage
        exit 1
      fi
      ;;
  esac
done

case "${TARGET}" in
  claude)
    TARGET_DIR="${HOME}/.claude/commands"
    ;;
  codex)
    TARGET_DIR="${HOME}/.codex/prompts"
    ;;
  *)
    echo "Error: unknown target '${TARGET}' (use claude or codex)"
    usage
    exit 1
    ;;
esac

echo "Installing TDD Claude Code Workflow..."
echo "  Source: ${REPO_DIR}"
echo "  Target: ${TARGET_DIR} (${TARGET})"

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

# Ensure target directory exists as a real directory
# If it's a symlink (from a previous install), replace with a real directory
if [ -L "${TARGET_DIR}" ]; then
  echo "  Replacing old directory symlink with per-file symlinks..."
  rm "${TARGET_DIR}"
fi
mkdir -p "${TARGET_DIR}"

# Symlink each command file individually, preserving any non-project files
echo "  Linking command files:"
for file in "${REPO_DIR}/commands/"*; do
  filename="$(basename "$file")"
  ln -sf "$file" "${TARGET_DIR}/${filename}"
  echo "    ${filename} -> ${file}"
done

echo ""
echo "Done. Command files are now symlinked."
