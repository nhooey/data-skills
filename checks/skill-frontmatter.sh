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
  frontmatter=$(awk 'NR == 1 && $0 != "---" { exit } NR > 1 && $0 == "---" { exit } NR > 1 { print }' "$file")
  name=$(sed -n 's/^name:[[:space:]]*//p' <<<"$frontmatter")
  # The description's text: what follows its key, or for a block scalar
  # (`|`, `>`, `|-`, ...) or an empty value, the indented lines under it.
  description=$(awk '
    in_description { if (/^[[:space:]]/ || /^$/) { print; next } exit }
    /^description:/ {
      value = $0
      sub(/^description:[[:space:]]*/, "", value)
      if (value !~ /^[|>][-+0-9]*[[:space:]]*$/) print value
      in_description = 1
    }
  ' <<<"$frontmatter")
  if [[ $name != "$dir" ]]; then
    echo "$dir: frontmatter name is '$name', not '$dir'" >&2
    status=1
  fi
  if [[ -z ${description//[[:space:]]/} ]]; then
    echo "$dir: frontmatter has no description" >&2
    status=1
  fi
done

exit "$status"
