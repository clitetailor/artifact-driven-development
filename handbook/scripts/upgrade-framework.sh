#!/usr/bin/env bash
# Upgrades framework-owned files in this vault from an upstream source.
#
# Framework-owned (overwritten via rsync --delete):
#   handbook/  reference/  agents/  README.md  _sources/
#
# 3-way merged (with .framework-cache/AGENTS.md as base):
#   AGENTS.md
#
# Never touched (user-owned):
#   _registry.md  templates/  conventions/  FRAMEWORK_VERSION (rewritten only at end)
#   and all vault artifact folders.
#
# Usage:
#   upgrade-framework.sh --source=<git-url|path> [--ref=<tag>] [--dry-run]
#
# --ref is REQUIRED when --source is a git URL (must be a tag for reproducibility).
# --ref is ignored when --source is a local path.

set -euo pipefail

SOURCE=""
REF=""
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    --source=*) SOURCE="${arg#--source=}" ;;
    --ref=*)    REF="${arg#--ref=}" ;;
    --dry-run)  DRY_RUN=1 ;;
    *)
      echo "Unknown argument: $arg"
      echo "Usage: upgrade-framework.sh --source=<git-url|path> [--ref=<tag>] [--dry-run]"
      exit 1
      ;;
  esac
done

if [[ -z "$SOURCE" ]]; then
  echo "Error: --source is required."
  exit 1
fi

# Detect source type
SOURCE_IS_URL=0
if [[ "$SOURCE" =~ ^(https?|git|ssh)://|^git@ ]]; then
  SOURCE_IS_URL=1
fi

if [[ $SOURCE_IS_URL -eq 1 && -z "$REF" ]]; then
  echo "Error: --ref=<tag> is required when --source is a git URL."
  echo "Hint: list available tags with: git ls-remote --tags $SOURCE"
  exit 1
fi

# Resolve source directory (clone if URL, otherwise use path directly)
CLEANUP_DIR=""
if [[ $SOURCE_IS_URL -eq 1 ]]; then
  CLEANUP_DIR="$(mktemp -d)"
  trap 'rm -rf "$CLEANUP_DIR"' EXIT
  echo "Cloning $SOURCE @ $REF into $CLEANUP_DIR ..."
  git clone --depth=1 --branch="$REF" "$SOURCE" "$CLEANUP_DIR" >/dev/null 2>&1 || {
    echo "Error: git clone failed. Verify the URL and that '$REF' is a valid tag/branch."
    exit 1
  }
  SOURCE_DIR="$CLEANUP_DIR"
else
  if [[ ! -d "$SOURCE" ]]; then
    echo "Error: --source path '$SOURCE' is not a directory."
    exit 1
  fi
  SOURCE_DIR="$(cd "$SOURCE" && pwd)"
fi

# Sanity-check source looks like an ADD vault
if [[ ! -f "$SOURCE_DIR/FRAMEWORK_VERSION" || ! -f "$SOURCE_DIR/AGENTS.md" ]]; then
  echo "Error: source does not look like an ADD vault (missing FRAMEWORK_VERSION or AGENTS.md)."
  exit 1
fi

SOURCE_VERSION="$(tr -d '[:space:]' < "$SOURCE_DIR/FRAMEWORK_VERSION")"
LOCAL_VERSION="$(tr -d '[:space:]' < ./FRAMEWORK_VERSION 2>/dev/null || echo 'unknown')"

echo "Local version : $LOCAL_VERSION"
echo "Source version: $SOURCE_VERSION"
echo

if [[ "$LOCAL_VERSION" == "$SOURCE_VERSION" ]]; then
  echo "Already at $SOURCE_VERSION. Re-running will re-sync framework files anyway."
fi

FRAMEWORK_DIRS=(handbook reference agents _sources)
FRAMEWORK_FILES=(README.md)

RSYNC_FLAGS=(-a --delete)
if [[ $DRY_RUN -eq 1 ]]; then
  RSYNC_FLAGS+=(--dry-run -i)
  echo "=== DRY RUN — no files will be changed ==="
fi

# Sync framework-owned directories
for d in "${FRAMEWORK_DIRS[@]}"; do
  if [[ -d "$SOURCE_DIR/$d" ]]; then
    echo "Syncing $d/ ..."
    mkdir -p "./$d"
    rsync "${RSYNC_FLAGS[@]}" "$SOURCE_DIR/$d/" "./$d/"
  else
    echo "Skip $d/ (not present in source)"
  fi
done

# Sync framework-owned single files
for f in "${FRAMEWORK_FILES[@]}"; do
  if [[ -f "$SOURCE_DIR/$f" ]]; then
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "would overwrite: $f"
    else
      cp "$SOURCE_DIR/$f" "./$f"
      echo "Overwrote: $f"
    fi
  fi
done

# 3-way merge AGENTS.md
echo
echo "Merging AGENTS.md (3-way) ..."
BASE=".framework-cache/AGENTS.md"
CURRENT="AGENTS.md"
NEW="$SOURCE_DIR/AGENTS.md"

if [[ ! -f "$BASE" ]]; then
  echo "Warning: no merge base at $BASE."
  echo "         Falling back to overwrite. Your local AGENTS.md edits (if any) will be lost."
  if [[ $DRY_RUN -eq 0 ]]; then
    mkdir -p .framework-cache
    cp "$NEW" "$CURRENT"
    cp "$NEW" "$BASE"
  fi
  AGENTS_STATUS="overwritten (no base)"
else
  TMP_MERGED="$(mktemp)"
  cp "$CURRENT" "$TMP_MERGED"
  if git merge-file -p "$CURRENT" "$BASE" "$NEW" > "$TMP_MERGED.out" 2>/dev/null; then
    AGENTS_STATUS="merged cleanly"
  else
    AGENTS_STATUS="MERGED WITH CONFLICTS — resolve <<<<<<< markers in AGENTS.md"
  fi
  if [[ $DRY_RUN -eq 0 ]]; then
    mv "$TMP_MERGED.out" "$CURRENT"
    # Update base to the new upstream version only if merge was clean.
    # If conflicted, leave the old base in place so the user can re-run after editing upstream or resolving.
    if [[ "$AGENTS_STATUS" == "merged cleanly" ]]; then
      cp "$NEW" "$BASE"
    fi
  else
    rm -f "$TMP_MERGED.out"
  fi
  rm -f "$TMP_MERGED"
fi

# Bump version stamp
if [[ $DRY_RUN -eq 0 ]]; then
  echo "$SOURCE_VERSION" > FRAMEWORK_VERSION
fi

echo
echo "=== Summary ==="
echo "Version    : $LOCAL_VERSION -> $SOURCE_VERSION"
echo "AGENTS.md  : $AGENTS_STATUS"
if [[ $DRY_RUN -eq 1 ]]; then
  echo "(dry run — no files changed)"
fi
echo
echo "Next steps:"
echo "  1. Review the diff: git diff (or jj diff)"
echo "  2. If AGENTS.md has conflict markers, resolve them, then re-run with the same --source to refresh the base."
echo "  3. Compare your local _registry.md against the source's reference/artifact-dep-graph.md for drift."
echo "  4. Commit the upgrade."
