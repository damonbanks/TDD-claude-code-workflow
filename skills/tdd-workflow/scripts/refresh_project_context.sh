#!/usr/bin/env bash
set -euo pipefail

FILE="ai-context/project-context.md"
FORCE=0

usage() {
  cat <<USAGE
Usage: $0 [--file <path>] [--force]

Initializes project-context.md when missing.
When --force is set, refreshes the Discovered date.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --file)
      FILE="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unexpected argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

today="$(date +%F)"
mkdir -p "$(dirname "$FILE")"

if [ ! -f "$FILE" ]; then
  cat > "$FILE" <<TEMPLATE
# Project Context

**Discovered**: $today

- **Language(s)**: TBD
- **Key frameworks**: TBD
- **Test framework**: TBD
- **Test command**: TBD
- **Lint command**: TBD
- **Format command**: TBD
- **Build command**: TBD
- **Code generation**: TBD
- **Git platform**: TBD
- **PR/MR command**: TBD
- **Commit convention**: TBD
TEMPLATE
  echo "$FILE"
  exit 0
fi

if [ "$FORCE" -eq 1 ]; then
  tmp_file="$(mktemp)"
  if grep -q '^\*\*Discovered\*\*:' "$FILE"; then
    sed -E "s/^\*\*Discovered\*\*: .*/**Discovered**: $today/" "$FILE" > "$tmp_file"
  else
    {
      echo "# Project Context"
      echo ""
      echo "**Discovered**: $today"
      echo ""
      cat "$FILE"
    } > "$tmp_file"
  fi
  mv "$tmp_file" "$FILE"
fi

echo "$FILE"
