#!/usr/bin/env bash
# Lists artifact files that no other artifact references via refs: frontmatter.
# These are candidates for cleanup review — not automatically stale.
# Usage: find-orphaned-artifacts.sh

set -euo pipefail

usage() {
  cat <<EOF
Usage: find-orphaned-artifacts.sh [-h]

Lists artifact files that no other artifact references via refs: frontmatter.
Output includes file path, artifact ID, and current status.
These are candidates for cleanup review — not automatically stale.
Exits 0 in all cases; review candidates manually before removing.

Options:
  -h, --help  Show this help message
EOF
}

for arg in "$@"; do
  case "$arg" in
    -h|--help) usage; exit 0 ;;
    *)
      echo "Unknown argument: $arg"
      usage
      exit 1
      ;;
  esac
done

ORPHANS=0

while IFS= read -r file; do
  id=$(grep -m1 "^id:" "$file" 2>/dev/null | sed 's/^id:[[:space:]]*//')
  [[ -z "$id" ]] && continue

  ref_count=$(grep -rl "  - ${id}" . \
    --include="*.md" \
    --exclude-dir=templates \
    --exclude-dir=_sources \
    --exclude-dir=handbook \
    --exclude-dir=reference \
    2>/dev/null | grep -cvF "$file" || true)

  if [[ "$ref_count" -eq 0 ]]; then
    status=$(grep -m1 "^status:" "$file" 2>/dev/null | sed 's/^status:[[:space:]]*//' || echo "unknown")
    echo "  $file  [id: $id, status: $status]"
    ORPHANS=$((ORPHANS + 1))
  fi
done < <(find . -name "*.md" \
  -not -path "./templates/*" \
  -not -path "./_sources/*" \
  -not -path "./handbook/*" \
  -not -path "./reference/*" \
  -not -path "./.jj/*" \
  -not -path "./.claude/*" \
  | sort)

if [[ $ORPHANS -eq 0 ]]; then
  echo "No orphaned artifacts found."
else
  echo ""
  echo "$ORPHANS orphaned artifact(s) found. Confirm with user before removing."
fi
