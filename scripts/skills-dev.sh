#!/usr/bin/env bash
# skills-dev: this repository's commands, run from anywhere in it.
# It finds the repository at $PRJ_ROOT, which the dev shell sets, or
# else at the top of the git checkout it runs in.
set -euo pipefail

prog=skills-dev
dry_run=0

usage() {
  cat <<EOF
Usage: $prog [-n|--dry-run] <command> [args...]

Commands:
  build [skill...]  build the named skills, or every skill
  lint [dir]        check each SKILL.md's frontmatter (default dir: skills)
  test [file...]    run the bats tests under tests/, or the files named

Options:
  -n, --dry-run     print the commands instead of running them
  -h, --help        show this help; '$prog <command> --help' shows a command's
EOF
}

build_usage() {
  cat <<EOF
Usage: $prog build [skill...]

Build the named skills' packages (agent-skill-nhooey-<skill>), or with
none named, the aggregate agent-skills-nhooey-data-all, which builds them all.
EOF
}

lint_usage() {
  cat <<EOF
Usage: $prog lint [dir]

Check that every <dir>/<skill>/SKILL.md opens with frontmatter whose name
equals <skill> and whose description is non-empty. dir defaults to skills/.
EOF
}

test_usage() {
  cat <<EOF
Usage: $prog test [file...]

Run the bats tests under tests/, or the files named, on the scripts in
the working tree.
EOF
}

die_usage() {
  echo "$prog: $1" >&2
  echo "Run '$prog --help' for usage." >&2
  exit 2
}

repo_root() {
  if [[ -n ${PRJ_ROOT:-} ]]; then
    echo "$PRJ_ROOT"
  elif git rev-parse --show-toplevel 2>/dev/null; then
    :
  else
    echo "$prog: not in the repository; set PRJ_ROOT or run it from a checkout" >&2
    exit 1
  fi
}

# run <command...>: run it, or print it under --dry-run.
run() {
  if ((dry_run)); then
    printf '%q ' "$@" | sed 's/ $//'
    echo
  else
    "$@"
  fi
}

# build_attr <skill>: the flake package that builds one skill.
build_attr() {
  echo "agent-skill-nhooey-$1"
}

cmd_build() {
  local root attrs=() skill
  root=$(repo_root)
  for skill in "$@"; do
    [[ -d $root/skills/$skill ]] || die_usage "build: no such skill: $skill"
    attrs+=("$root#$(build_attr "$skill")")
  done
  ((${#attrs[@]})) || attrs=("$root#agent-skills-nhooey-data-all")
  run nix build --no-link --print-build-logs "${attrs[@]}"
}

cmd_lint() {
  (($# <= 1)) || die_usage "lint: takes at most one directory"
  local root
  root=$(repo_root)
  run bash "$root/checks/skill-frontmatter.sh" "${1:-$root/skills}"
}

cmd_test() {
  local root
  root=$(repo_root)
  (($#)) || set -- "$root/tests"
  run env SKILL_FRONTMATTER="$root/checks/skill-frontmatter.sh" \
    SKILLS_DIR="$root/skills" bats "$@"
}

main() {
  while (($#)); do
    case $1 in
    -n | --dry-run) dry_run=1 ;;
    -h | --help)
      usage
      return 0
      ;;
    -*) die_usage "unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done
  (($#)) || die_usage "no command given"

  local command=$1
  shift
  case $command in
  build | lint | test) ;;
  *) die_usage "unknown command: $command" ;;
  esac
  if [[ ${1:-} == -h || ${1:-} == --help ]]; then
    "${command}_usage"
    return 0
  fi
  "cmd_$command" "$@"
}

main "$@"
