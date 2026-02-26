#!/usr/bin/env bash
set -euo pipefail

ALLOW_MAIN=0

usage() {
  cat <<USAGE
Usage: $0 [--allow-main]

Checks the current git branch.
- exits 0 when branch is acceptable
- exits 2 when on main/master and --allow-main is not set
- exits 1 on other errors
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --allow-main)
      ALLOW_MAIN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error=unexpected_argument value=$1"
      usage
      exit 1
      ;;
  esac
done

branch="$(git branch --show-current 2>/dev/null || true)"
if [ -z "$branch" ]; then
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
fi

if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
  echo "status=error"
  echo "message=Unable to determine current branch"
  exit 1
fi

if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
  if [ "$ALLOW_MAIN" -eq 1 ]; then
    echo "status=ok"
    echo "branch=$branch"
    echo "message=On protected branch but allowed for read-only workflow steps"
    exit 0
  fi

  echo "status=blocked"
  echo "branch=$branch"
  echo "message=Code-writing phases are not allowed on main/master"
  exit 2
fi

echo "status=ok"
echo "branch=$branch"
echo "message=Feature branch is safe for write phases"
