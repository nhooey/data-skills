# data-skills

A Nix flake for [Agent Skills](https://www.anthropic.com/engineering/agent-skills) about working with data, plus a dev shell that installs a curated skill-authoring toolkit at project scope.

Skills are built and installed with [`agent-skill-flake`](https://github.com/nhooey/agent-skill-flake).

## The skills

This repository holds no skills for now: `skills/` is empty, and the flake builds an empty skill set. Comparison tables are covered by [`writing-hygiene-tables-for-comparison`](https://github.com/nhooey/writing-skills), for when and what to compare, and [`markdown-hygiene-lists-headings-tables`](https://github.com/nhooey/document-skills), for the table's layout.

## Install

```sh
# install this repository's skills at personal scope (~/.claude/skills/)
nix run github:nhooey/data-skills#install -- --scope=personal

# or at project scope (<repo-root>/.claude/skills/)
nix run github:nhooey/data-skills#install -- --scope=project

# preview / remove
nix run github:nhooey/data-skills#preview   -- --scope=personal
nix run github:nhooey/data-skills#uninstall -- --scope=personal
```

`--scope` is required on every invocation; see the [`agent-skill-flake` install-scope docs](https://github.com/nhooey/agent-skill-flake#install-scope) for the resolver semantics.

## Dev shell

`nix develop` installs the skills used to work on this repo, at project scope, into `<repo-root>/.agents/skills/`, with `.claude/skills` a symlink to it. The set comes from the `skills-devshell/` sub-flake: skillspkgs' [`authoring-with-git`](https://github.com/nhooey/skillspkgs) combination (nix, humanizer, skill-creation, superpowers and the whole git/GitHub pack), [`shell-skills`](https://github.com/nhooey/shell-skills), and three skills from [`coding-agent-skills`](https://github.com/nhooey/coding-agent-skills). The set is converged on shell entry: missing skills are installed, changed ones updated, and renamed or dropped ones swept.

The shell's commands:

- `check`: run `nix flake check`, which formats through treefmt, builds every skill, and checks each `SKILL.md`'s frontmatter `name` and `description`.
- `fmt`: format the tree with treefmt.
- `skills-dev`: this repository's own tool, in [`scripts/skills-dev.sh`](scripts/skills-dev.sh). `skills-dev build` builds every skill, or the ones named; `skills-dev lint` checks each `SKILL.md`'s frontmatter; `skills-dev test` runs the bats tests under `tests/`. `skills-dev --help` lists its commands and options.
- `update-flake`: update `flake.lock`.
- `update-skills-devshell`: update the `skills-devshell/` sub-flake's lock.
- `reap-skills`: remove every skill the dev shell installed.
