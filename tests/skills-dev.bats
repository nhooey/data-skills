#!/usr/bin/env bats
# Tests for scripts/skills-dev.sh: its argument parsing, and the commands
# it would run, printed under --dry-run against a fixture repository. Set
# SKILLS_DEV to the tool's path; it defaults to the copy in this
# repository, run with bash.

setup() {
  if [[ -n ${SKILLS_DEV:-} ]]; then
    tool=("$SKILLS_DEV")
  else
    tool=(bash "$BATS_TEST_DIRNAME/../scripts/skills-dev.sh")
  fi
  export PRJ_ROOT=$BATS_TEST_TMPDIR/repo
  mkdir -p "$PRJ_ROOT/skills/data-one" "$PRJ_ROOT/skills/data-two"
}

@test "--help lists every command and option" {
  run "${tool[@]}" --help
  [ "$status" -eq 0 ]
  for token in build lint test --dry-run --help; do
    [[ $output == *"$token"* ]]
  done
}

@test "each command takes --help" {
  for command in build lint test; do
    run "${tool[@]}" "$command" --help
    [ "$status" -eq 0 ]
    [[ $output == "Usage: skills-dev $command"* ]]
  done
}

@test "no command is a usage error" {
  run "${tool[@]}"
  [ "$status" -eq 2 ]
  [[ $output == *"no command given"* ]]
}

@test "an unknown command is a usage error" {
  run "${tool[@]}" deploy
  [ "$status" -eq 2 ]
  [[ $output == *"unknown command: deploy"* ]]
}

@test "an unknown option is a usage error" {
  run "${tool[@]}" --frobnicate build
  [ "$status" -eq 2 ]
  [[ $output == *"unknown option: --frobnicate"* ]]
}

@test "build with no skills builds the aggregate" {
  run "${tool[@]}" --dry-run build
  [ "$status" -eq 0 ]
  [ "$output" = "nix build --no-link --print-build-logs $PRJ_ROOT#agent-skills-nhooey-data-all" ]
}

@test "build names each skill's package" {
  run "${tool[@]}" -n build data-one data-two
  [ "$status" -eq 0 ]
  [ "$output" = "nix build --no-link --print-build-logs $PRJ_ROOT#agent-skill-nhooey-data-one $PRJ_ROOT#agent-skill-nhooey-data-two" ]
}

@test "build refuses a skill that isn't there" {
  run "${tool[@]}" -n build data-missing
  [ "$status" -eq 2 ]
  [[ $output == *"no such skill: data-missing"* ]]
}

@test "lint checks skills/ by default" {
  run "${tool[@]}" -n lint
  [ "$status" -eq 0 ]
  [ "$output" = "bash $PRJ_ROOT/checks/skill-frontmatter.sh $PRJ_ROOT/skills" ]
}

@test "lint checks the directory named" {
  run "${tool[@]}" -n lint other
  [ "$status" -eq 0 ]
  [ "$output" = "bash $PRJ_ROOT/checks/skill-frontmatter.sh other" ]
}

@test "lint takes at most one directory" {
  run "${tool[@]}" -n lint one two
  [ "$status" -eq 2 ]
}

@test "test runs tests/ on the working tree's check" {
  run "${tool[@]}" -n test
  [ "$status" -eq 0 ]
  [ "$output" = "env SKILL_FRONTMATTER=$PRJ_ROOT/checks/skill-frontmatter.sh SKILLS_DIR=$PRJ_ROOT/skills bats $PRJ_ROOT/tests" ]
}

@test "test runs the files named" {
  run "${tool[@]}" -n test tests/one.bats
  [ "$status" -eq 0 ]
  [[ $output == *" bats tests/one.bats" ]]
}

@test "lint runs the frontmatter check" {
  check=${SKILL_FRONTMATTER:-$BATS_TEST_DIRNAME/../checks/skill-frontmatter.sh}
  mkdir -p "$PRJ_ROOT/checks"
  cp "$check" "$PRJ_ROOT/checks/skill-frontmatter.sh"
  printf -- '---\nname: data-one\ndescription: One.\n---\n' >"$PRJ_ROOT/skills/data-one/SKILL.md"
  printf -- '---\nname: wrong\ndescription: Two.\n---\n' >"$PRJ_ROOT/skills/data-two/SKILL.md"
  run "${tool[@]}" lint
  [ "$status" -eq 1 ]
  [[ $output == *"data-two: frontmatter name is 'wrong', not 'data-two'"* ]]
}
