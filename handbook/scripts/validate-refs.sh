#!/usr/bin/env bash
# Validates that every ref ID in artifact frontmatter resolves to a real file.
# Usage: validate-refs.sh

set -euo pipefail

BROKEN=0
CHECKED=0

while IFS= read -r file; do
  in_frontmatter=0
  in_refs=0

  while IFS= read -r line; do
    # Track frontmatter boundaries
    if [[ "$line" == "---" ]]; then
      if [[ $in_frontmatter -eq 0 ]]; then
        in_frontmatter=1
      else
        break
      fi
      continue
    fi
    [[ $in_frontmatter -eq 0 ]] && continue

    # Enter refs block
    if [[ "$line" =~ ^refs: ]]; then
      in_refs=1
      continue
    fi

    # Exit refs block on next top-level key
    if [[ $in_refs -eq 1 && "$line" =~ ^[a-zA-Z] ]]; then
      in_refs=0
      continue
    fi

    # Process each ref entry
    if [[ $in_refs -eq 1 && "$line" =~ ^[[:space:]]+-[[:space:]] ]]; then
      ref_id=$(echo "$line" | sed 's/^[[:space:]]*-[[:space:]]*//' | sed 's/#.*//' | tr -d ' "')
      [[ -z "$ref_id" || "$ref_id" == "~" ]] && continue

      CHECKED=$((CHECKED + 1))

      match=$(find . -name "${ref_id}.md" \
        -not -path "./templates/*" \
        -not -path "./_sources/*" \
        -not -path "./handbook/*" \
        -not -path "./reference/*" \
        -not -path "./.jj/*" \
        -not -path "./.claude/*" \
        2>/dev/null | head -1)

      if [[ -z "$match" ]]; then
        echo "BROKEN  ${file} → ${ref_id}"
        BROKEN=$((BROKEN + 1))
      fi
    fi
  done < "$file"
done < <(find . -name "*.md" \
  -not -path "./templates/*" \
  -not -path "./_sources/*" \
  -not -path "./handbook/*" \
  -not -path "./reference/*" \
  -not -path "./.jj/*" \
  -not -path "./.claude/*" \
  | sort)

echo ""
echo "Checked $CHECKED refs — $BROKEN broken."
[[ $BROKEN -gt 0 ]] && exit 1 || exit 0
