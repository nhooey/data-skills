#!/usr/bin/env bash
# Fail unless every skills/<dir>/SKILL.md opens with YAML frontmatter,
# closed by a second `---` line, whose `name` equals <dir> and whose
# `description` is non-empty. A directory with no skills passes.
set -euo pipefail
shopt -s nullglob

skills_dir=$1
status=0

for skill in "$skills_dir"/*/; do
  dir=$(basename "$skill")
  file="$skill/SKILL.md"
  if [[ ! -f $file ]]; then
    echo "$dir: no SKILL.md" >&2
    status=1
    continue
  fi
  if ! awk 'NR == 1 && $0 != "---" { exit 1 } NR > 1 && $0 == "---" { closed = 1; exit } END { exit !closed }' "$file"; then
    echo "$dir: SKILL.md has no frontmatter closed by a '---' line" >&2
    status=1
    continue
  fi
  # yq's front-matter mode reads the values as YAML; it doesn't report a
  # missing block, which the awk above gates.
  if ! name=$(yq --front-matter=extract '.name // ""' "$file" 2>&1) ||
    ! description=$(yq --front-matter=extract '.description // ""' "$file" 2>&1); then
    echo "$dir: SKILL.md frontmatter is not valid YAML" >&2
    status=1
    continue
  fi
  if [[ $name != "$dir" ]]; then
    echo "$dir: frontmatter name is '$name', not '$dir'" >&2
    status=1
  fi
  if [[ -z $description ]]; then
    echo "$dir: frontmatter has no description" >&2
    status=1
  fi
done

exit "$status"
