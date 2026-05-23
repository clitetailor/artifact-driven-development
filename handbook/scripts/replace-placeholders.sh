#!/usr/bin/env bash
# Replaces repo name placeholders across vault .md files.
# All repo flags are optional except --docs-repo.
# Omit a flag (or pass "none") to skip that placeholder.
#
# Usage:
#   replace-placeholders.sh --docs-repo=<name> [--frontend-repo=<name>]
#                           [--backend-repo=<name>] [--infra-repo=<name>]
#                           [--dry-run]

set -euo pipefail

DOCS_REPO=""
FRONTEND_REPO=""
BACKEND_REPO=""
INFRA_REPO=""
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    --docs-repo=*)     DOCS_REPO="${arg#--docs-repo=}" ;;
    --frontend-repo=*) FRONTEND_REPO="${arg#--frontend-repo=}" ;;
    --backend-repo=*)  BACKEND_REPO="${arg#--backend-repo=}" ;;
    --infra-repo=*)    INFRA_REPO="${arg#--infra-repo=}" ;;
    --dry-run)         DRY_RUN=1 ;;
    *)
      echo "Unknown argument: $arg"
      echo "Usage: replace-placeholders.sh --docs-repo=<name> [--frontend-repo=<name>] [--backend-repo=<name>] [--infra-repo=<name>] [--dry-run]"
      exit 1
      ;;
  esac
done

if [[ -z "$DOCS_REPO" ]]; then
  echo "Error: --docs-repo is required."
  exit 1
fi

# Normalize "none" to empty so those placeholders are skipped
[[ "$FRONTEND_REPO" == "none" ]] && FRONTEND_REPO=""
[[ "$BACKEND_REPO"  == "none" ]] && BACKEND_REPO=""
[[ "$INFRA_REPO"    == "none" ]] && INFRA_REPO=""

# Build sed expression from non-empty replacements
SED_EXPR="-e s|{docs-repo}|$DOCS_REPO|g"
[[ -n "$FRONTEND_REPO" ]] && SED_EXPR="$SED_EXPR -e s|{frontend-repo}|$FRONTEND_REPO|g"
[[ -n "$BACKEND_REPO"  ]] && SED_EXPR="$SED_EXPR -e s|{backend-repo}|$BACKEND_REPO|g"
[[ -n "$INFRA_REPO"    ]] && SED_EXPR="$SED_EXPR -e s|{infra-repo}|$INFRA_REPO|g"

# Build grep pattern for files that contain at least one active placeholder
PATTERN="{docs-repo}"
[[ -n "$FRONTEND_REPO" ]] && PATTERN="$PATTERN\|{frontend-repo}"
[[ -n "$BACKEND_REPO"  ]] && PATTERN="$PATTERN\|{backend-repo}"
[[ -n "$INFRA_REPO"    ]] && PATTERN="$PATTERN\|{infra-repo}"

COUNT=0

while IFS= read -r f; do
  if grep -q "$PATTERN" "$f" 2>/dev/null; then
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "  would update: $f"
    else
      eval sed -i "$SED_EXPR" "\"$f\""
    fi
    COUNT=$((COUNT + 1))
  fi
done < <(find . -name "*.md" \
  -not -path "./_sources/*" \
  -not -path "./handbook/guide/*" \
  -not -path "./.jj/*" \
  -not -path "./.claude/*")

if [[ $DRY_RUN -eq 1 ]]; then
  echo "$COUNT file(s) would be updated."
else
  echo "Replaced placeholders in $COUNT file(s)."
fi
