#!/usr/bin/env bats
# Tests for checks/skill-frontmatter.sh. Each test builds a skills
# directory in a temporary directory and runs the check on it. Set
# SKILL_FRONTMATTER to the script's path; it defaults to the copy in
# this repository.

setup() {
  check=${SKILL_FRONTMATTER:-$BATS_TEST_DIRNAME/../checks/skill-frontmatter.sh}
  skills=$BATS_TEST_TMPDIR/skills
  mkdir -p "$skills"
}

# write_skill <dir> <SKILL.md contents>
write_skill() {
  mkdir -p "$skills/$1"
  printf '%s' "$2" >"$skills/$1/SKILL.md"
}

valid_skill() {
  write_skill "$1" "---
name: $1
description: Does one thing well.
---

# $1
"
}

@test "passes a skill whose name matches its directory and has a description" {
  valid_skill good-skill
  run bash "$check" "$skills"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "passes several valid skills" {
  valid_skill first-skill
  valid_skill second-skill
  run bash "$check" "$skills"
  [ "$status" -eq 0 ]
}

@test "passes a skills directory with no skills" {
  run bash "$check" "$skills"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "fails when the frontmatter name differs from the directory" {
  write_skill right-name "---
name: wrong-name
description: Does one thing well.
---
"
  run bash "$check" "$skills"
  [ "$status" -eq 1 ]
  [[ $output == *"right-name: frontmatter name is 'wrong-name', not 'right-name'"* ]]
}

@test "fails when the frontmatter has no name" {
  write_skill nameless "---
description: Does one thing well.
---
"
  run bash "$check" "$skills"
  [ "$status" -eq 1 ]
  [[ $output == *"nameless: frontmatter name is '', not 'nameless'"* ]]
}

@test "fails when the frontmatter has no description" {
  write_skill no-description "---
name: no-description
---
"
  run bash "$check" "$skills"
  [ "$status" -eq 1 ]
  [[ $output == *"no-description: frontmatter has no description"* ]]
}

@test "fails when the description is empty" {
  write_skill empty-description "---
name: empty-description
description:
---
"
  run bash "$check" "$skills"
  [ "$status" -eq 1 ]
  [[ $output == *"empty-description: frontmatter has no description"* ]]
}

@test "reads name and description only from the frontmatter, not the body" {
  write_skill body-only "---
title: Body only
---

name: body-only
description: In the body, so it doesn't count.
"
  run bash "$check" "$skills"
  [ "$status" -eq 1 ]
  [[ $output == *"body-only: frontmatter name is '', not 'body-only'"* ]]
  [[ $output == *"body-only: frontmatter has no description"* ]]
}

@test "fails when SKILL.md doesn't open with frontmatter" {
  write_skill no-frontmatter "# no-frontmatter

name: no-frontmatter
description: Does one thing well.
"
  run bash "$check" "$skills"
  [ "$status" -eq 1 ]
  [[ $output == *"no-frontmatter: SKILL.md has no frontmatter closed by a '---' line"* ]]
}

@test "fails when the frontmatter is never closed" {
  write_skill unclosed "---
name: unclosed
description: Does one thing well.

# unclosed
"
  run bash "$check" "$skills"
  [ "$status" -eq 1 ]
  [[ $output == *"unclosed: SKILL.md has no frontmatter closed by a '---' line"* ]]
}

@test "fails when a skill directory has no SKILL.md" {
  mkdir -p "$skills/empty-dir"
  run bash "$check" "$skills"
  [ "$status" -eq 1 ]
  [[ $output == *"empty-dir: no SKILL.md"* ]]
}

@test "fails on a bad skill even when the others are valid" {
  valid_skill good-skill
  write_skill bad-skill "---
name: other-name
description: Does one thing well.
---
"
  valid_skill zzz-skill
  run bash "$check" "$skills"
  [ "$status" -eq 1 ]
  [[ $output == *"bad-skill: frontmatter name is 'other-name'"* ]]
  [[ $output != *"good-skill:"* ]]
  [[ $output != *"zzz-skill:"* ]]
}

@test "passes this repository's skills" {
  run bash "$check" "${SKILLS_DIR:-$BATS_TEST_DIRNAME/../skills}"
  [ "$status" -eq 0 ]
}
