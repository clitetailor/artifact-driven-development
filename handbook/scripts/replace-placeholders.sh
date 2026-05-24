#!/usr/bin/env bash
# Replaces repo name placeholders across vault .md files.
# All repo flags are optional except --docs-repo.
# Omit a flag (or pass "none") to skip that placeholder.
#
# Repo names are persisted to .add/config after a successful run so that
# upgrade-framework.sh can re-apply them automatically after each upgrade.
# If no flags are given, values are read from .add/config (must exist).
#
# Usage:
#   replace-placeholders.sh --docs-repo=<name> [--frontend-repo=<name>]
#                           [--backend-repo=<name>] [--infra-repo=<name>]
#                           [--dry-run]
#   replace-placeholders.sh  # reads from .add/config

set -euo pipefail

usage() {
  cat <<EOF
Usage: replace-placeholders.sh --docs-repo=<name> [--frontend-repo=<name>]
                                [--backend-repo=<name>] [--infra-repo=<name>]
                                [--dry-run]
       replace-placeholders.sh   # reads repo names from .add/config

Options:
  --docs-repo=<name>      Docs repo name (required unless .add/config exists)
  --frontend-repo=<name>  Frontend repo name (optional; pass "none" to skip)
  --backend-repo=<name>   Backend repo name (optional; pass "none" to skip)
  --infra-repo=<name>     Infra repo name (optional; pass "none" to skip)
  --dry-run               Print files that would change without modifying them
  -h, --help              Show this help message
EOF
}

ADD_CONFIG=".add/config"

DOCS_REPO=""
FRONTEND_REPO=""
BACKEND_REPO=""
INFRA_REPO=""
DRY_RUN=0
FLAGS_GIVEN=0

for arg in "$@"; do
  case "$arg" in
    --docs-repo=*)     DOCS_REPO="${arg#--docs-repo=}";     FLAGS_GIVEN=1 ;;
    --frontend-repo=*) FRONTEND_REPO="${arg#--frontend-repo=}"; FLAGS_GIVEN=1 ;;
    --backend-repo=*)  BACKEND_REPO="${arg#--backend-repo=}";  FLAGS_GIVEN=1 ;;
    --infra-repo=*)    INFRA_REPO="${arg#--infra-repo=}";   FLAGS_GIVEN=1 ;;
    --dry-run)         DRY_RUN=1 ;;
    -h|--help)         usage; exit 0 ;;
    *)
      echo "Unknown argument: $arg"
      usage
      exit 1
      ;;
  esac
done

# If no repo flags were given, load values from .add/config
if [[ $FLAGS_GIVEN -eq 0 ]]; then
  if [[ ! -f "$ADD_CONFIG" ]]; then
    echo "Error: no repo flags given and $ADD_CONFIG not found."
    echo "Run with --docs-repo=<name> (and optional --frontend/backend/infra-repo) to create it."
    exit 1
  fi
  echo "Reading repo names from $ADD_CONFIG ..."
  while IFS='=' read -r key value; do
    [[ "$key" =~ ^#|^[[:space:]]*$ ]] && continue
    case "$key" in
      docs-repo)     DOCS_REPO="$value" ;;
      frontend-repo) FRONTEND_REPO="$value" ;;
      backend-repo)  BACKEND_REPO="$value" ;;
      infra-repo)    INFRA_REPO="$value" ;;
    esac
  done < "$ADD_CONFIG"
fi

if [[ -z "$DOCS_REPO" ]]; then
  echo "Error: --docs-repo is required."
  exit 1
fi

# Normalize "none" to empty so those placeholders are skipped
[[ "$FRONTEND_REPO" == "none" ]] && FRONTEND_REPO=""
[[ "$BACKEND_REPO"  == "none" ]] && BACKEND_REPO=""
[[ "$INFRA_REPO"    == "none" ]] && INFRA_REPO=""

# Persist the resolved values to .add/config (unless dry-run)
if [[ $DRY_RUN -eq 0 ]]; then
  {
    echo "docs-repo=$DOCS_REPO"
    [[ -n "$FRONTEND_REPO" ]] && echo "frontend-repo=$FRONTEND_REPO"
    [[ -n "$BACKEND_REPO"  ]] && echo "backend-repo=$BACKEND_REPO"
    [[ -n "$INFRA_REPO"    ]] && echo "infra-repo=$INFRA_REPO"
  } > "$ADD_CONFIG"
fi

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
