#!/usr/bin/env bash
set -euo pipefail

FILE="ai-context/current-work.md"
WORK_TYPE=""
FEATURE=""
TICKET=""
STARTED=""
PHASE=""
BRANCH=""
SPEC_PATH=""
TESTS_PATH=""
RESEARCH_PATH=""
IMPLEMENTATION_PATH=""
REFACTORING_PATH=""
ADD_COMPLETED=""
SET_COMPLETED=""
NOTES_TO_ADD=""

VALID_KEYS="spec test_happy research implement_happy test_error implement_error test_edge implement_edge refactor"

usage() {
  cat <<USAGE
Usage: $0 [options]

Options:
  --file <path>
  --work-type <value>
  --feature <value>
  --ticket <value>
  --started <YYYY-MM-DD>
  --phase <value>
  --branch <value>
  --spec <path>
  --tests <path>
  --research <path>
  --implementation <path>
  --refactoring <path>
  --completed <comma-separated-keys>
  --set-completed <comma-separated-keys>
  --note <text>  (repeatable)

Completion keys:
  spec, test_happy, research, implement_happy,
  test_error, implement_error, test_edge, implement_edge, refactor
USAGE
}

parse_csv_keys() {
  printf '%s' "$1" | tr ',;' '  ' | xargs
}

is_valid_key() {
  key="$1"
  for valid in $VALID_KEYS; do
    if [ "$key" = "$valid" ]; then
      return 0
    fi
  done
  return 1
}

normalize_keys() {
  raw="$1"
  out=""
  for key in $(parse_csv_keys "$raw"); do
    if ! is_valid_key "$key"; then
      echo "Invalid completion key: $key" >&2
      exit 1
    fi
    case " $out " in
      *" $key "*) ;;
      *) out="$out $key" ;;
    esac
  done
  printf '%s' "$(echo "$out" | xargs)"
}

contains_key() {
  list="$1"
  key="$2"
  case " $list " in
    *" $key "*) return 0 ;;
    *) return 1 ;;
  esac
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --file)
      FILE="$2"
      shift 2
      ;;
    --work-type)
      WORK_TYPE="$2"
      shift 2
      ;;
    --feature)
      FEATURE="$2"
      shift 2
      ;;
    --ticket)
      TICKET="$2"
      shift 2
      ;;
    --started)
      STARTED="$2"
      shift 2
      ;;
    --phase)
      PHASE="$2"
      shift 2
      ;;
    --branch)
      BRANCH="$2"
      shift 2
      ;;
    --spec)
      SPEC_PATH="$2"
      shift 2
      ;;
    --tests)
      TESTS_PATH="$2"
      shift 2
      ;;
    --research)
      RESEARCH_PATH="$2"
      shift 2
      ;;
    --implementation)
      IMPLEMENTATION_PATH="$2"
      shift 2
      ;;
    --refactoring)
      REFACTORING_PATH="$2"
      shift 2
      ;;
    --completed)
      ADD_COMPLETED="$2"
      shift 2
      ;;
    --set-completed)
      SET_COMPLETED="$2"
      shift 2
      ;;
    --note)
      if [ -n "$NOTES_TO_ADD" ]; then
        NOTES_TO_ADD="$NOTES_TO_ADD\n$2"
      else
        NOTES_TO_ADD="$2"
      fi
      shift 2
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

mkdir -p "$(dirname "$FILE")"

if [ -f "$FILE" ]; then
  existing_type="$(sed -n 's/^\*\*Type\*\*: //p' "$FILE" | head -n1)"
  existing_feature="$(sed -n 's/^\*\*Feature\*\*: //p' "$FILE" | head -n1)"
  existing_ticket="$(sed -n 's/^\*\*Ticket\*\*: //p' "$FILE" | head -n1)"
  existing_started="$(sed -n 's/^\*\*Started\*\*: //p' "$FILE" | head -n1)"
  existing_phase="$(sed -n 's/^\*\*Current Phase\*\*: //p' "$FILE" | head -n1)"
  existing_branch="$(sed -n 's/^\*\*Branch\*\*: //p' "$FILE" | head -n1)"

  existing_spec="$(sed -n 's/^- Spec: //p' "$FILE" | head -n1)"
  existing_tests="$(sed -n 's/^- Tests: //p' "$FILE" | head -n1)"
  existing_research="$(sed -n 's/^- Research: //p' "$FILE" | head -n1)"
  existing_impl="$(sed -n 's/^- Implementation: //p' "$FILE" | head -n1)"
  existing_refactor="$(sed -n 's/^- Refactoring: //p' "$FILE" | head -n1)"

  existing_completed="$(sed -n 's/^<!-- completed: \(.*\) -->$/\1/p' "$FILE" | head -n1)"
  existing_notes="$(awk 'found{print} /^## Notes$/{found=1}' "$FILE" | sed '1d')"
else
  existing_type=""
  existing_feature=""
  existing_ticket=""
  existing_started=""
  existing_phase=""
  existing_branch=""
  existing_spec="(pending)"
  existing_tests="(pending)"
  existing_research="(pending)"
  existing_impl="(pending)"
  existing_refactor="(pending)"
  existing_completed=""
  existing_notes="- "
fi

final_type="${WORK_TYPE:-$existing_type}"
final_feature="${FEATURE:-$existing_feature}"
final_ticket="${TICKET:-$existing_ticket}"
final_started="${STARTED:-$existing_started}"
final_phase="${PHASE:-$existing_phase}"
final_branch="${BRANCH:-$existing_branch}"

if [ -z "$final_started" ]; then
  final_started="$(date +%F)"
fi

if [ -z "$final_branch" ]; then
  final_branch="$(git branch --show-current 2>/dev/null || true)"
fi

final_spec="${SPEC_PATH:-$existing_spec}"
final_tests="${TESTS_PATH:-$existing_tests}"
final_research="${RESEARCH_PATH:-$existing_research}"
final_impl="${IMPLEMENTATION_PATH:-$existing_impl}"
final_refactor="${REFACTORING_PATH:-$existing_refactor}"

if [ -n "$SET_COMPLETED" ]; then
  final_completed="$(normalize_keys "$SET_COMPLETED")"
else
  base_completed="$(normalize_keys "$existing_completed")"
  add_completed="$(normalize_keys "$ADD_COMPLETED")"
  final_completed="$base_completed"
  for key in $add_completed; do
    if ! contains_key "$final_completed" "$key"; then
      final_completed="$(echo "$final_completed $key" | xargs)"
    fi
  done
fi

if [ -z "$existing_notes" ]; then
  existing_notes="- "
fi

final_notes="$existing_notes"
if [ -n "$NOTES_TO_ADD" ]; then
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    if [ "$line" = "${line#- }" ]; then
      final_notes="$final_notes\n- $line"
    else
      final_notes="$final_notes\n$line"
    fi
  done <<NOTES
$NOTES_TO_ADD
NOTES
fi

checkbox_line() {
  key="$1"
  label="$2"
  if contains_key "$final_completed" "$key"; then
    printf -- '- [x] %s\n' "$label"
  else
    printf -- '- [ ] %s\n' "$label"
  fi
}

tmp_file="$(mktemp)"
{
  echo "# Current Work"
  echo ""
  printf '<!-- completed: %s -->\n' "$final_completed"
  echo ""
  printf '**Type**: %s\n' "$final_type"
  printf '**Feature**: %s\n' "$final_feature"
  printf '**Ticket**: %s\n' "$final_ticket"
  printf '**Started**: %s\n' "$final_started"
  printf '**Current Phase**: %s\n' "$final_phase"
  printf '**Branch**: %s\n' "$final_branch"
  echo ""
  echo "## Artifacts"
  printf -- '- Spec: %s\n' "$final_spec"
  printf -- '- Tests: %s\n' "$final_tests"
  printf -- '- Research: %s\n' "$final_research"
  printf -- '- Implementation: %s\n' "$final_impl"
  printf -- '- Refactoring: %s\n' "$final_refactor"
  echo ""
  echo "## Status"
  checkbox_line "spec" "Spec Phase"
  checkbox_line "test_happy" "Test Phase - Happy Path"
  checkbox_line "research" "Research Phase"
  checkbox_line "implement_happy" "Implement Phase - Happy Path"
  checkbox_line "test_error" "Test Phase - Error Handling"
  checkbox_line "implement_error" "Implement Phase - Error Handling"
  checkbox_line "test_edge" "Test Phase - Edge Cases"
  checkbox_line "implement_edge" "Implement Phase - Edge Cases"
  checkbox_line "refactor" "Refactor Phase"
  echo ""
  echo "## Notes"
  printf '%b\n' "$final_notes"
} > "$tmp_file"

mv "$tmp_file" "$FILE"

echo "$FILE"
