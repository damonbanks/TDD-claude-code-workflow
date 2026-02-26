#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage: $0 <type> <feature-slug-or-title> [ticket-id] [date]

Types: spec, tests, research, implementation, refactoring, analysis
Outputs an artifact path under ai-context/.
USAGE
}

sanitize_slug() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-{2,}/-/g'
}

sanitize_token() {
  printf '%s' "$1" \
    | sed -E 's/[^A-Za-z0-9._-]+/-/g; s/^-+//; s/-+$//; s/-{2,}/-/g'
}

if [ "$#" -lt 2 ] || [ "$#" -gt 4 ]; then
  usage
  exit 1
fi

type="$1"
raw_feature="$2"
ticket="${3:-}"
date_part="${4:-$(date +%F)}"

case "$type" in
  spec)
    dir="specs"
    ;;
  tests)
    dir="tests"
    ;;
  research)
    dir="research"
    ;;
  implementation)
    dir="implementation"
    ;;
  refactoring)
    dir="refactoring"
    ;;
  analysis)
    dir="bugs"
    ;;
  *)
    echo "Unsupported type: $type"
    usage
    exit 1
    ;;
esac

feature="$(sanitize_slug "$raw_feature")"
if [ -z "$feature" ]; then
  echo "Feature slug/title produced an empty slug"
  exit 1
fi

clean_ticket=""
if [ -n "$ticket" ]; then
  clean_ticket="$(sanitize_token "$ticket")"
fi

if [ -n "$clean_ticket" ]; then
  filename="${date_part}_${clean_ticket}_${feature}_${type}.md"
else
  filename="${date_part}_${feature}_${type}.md"
fi

printf 'ai-context/%s/%s\n' "$dir" "$filename"
