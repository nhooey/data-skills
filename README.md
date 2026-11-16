# data-skills

A Nix flake packaging the [`data-comparison-tables`](skills/data-comparison-tables/SKILL.md) [Agent Skill](https://www.anthropic.com/engineering/agent-skills) — guidance for writing scannable Markdown comparison tables — plus a dev shell that installs a curated skill-authoring toolkit at project scope.

Skills are built and installed with [`agent-skill-flake`](https://github.com/nhooey/agent-skill-flake).

## The skill

- **`data-comparison-tables`** — when writing a Markdown document that compares two or more concrete things (products, libraries, services, frameworks, …), shape it as a table a reader can scan in seconds: items in rows, properties in columns, binary values as ✅/❌, hyperlinked names, and uniform properties pulled out into a list beneath.

## Install

```sh
# install data-comparison-tables at personal scope (~/.claude/skills/)
nix run github:nhooey/data-skills#install -- --scope=personal

# or at project scope (<repo-root>/.claude/skills/)
nix run github:nhooey/data-skills#install -- --scope=project

# preview / remove
nix run github:nhooey/data-skills#preview   -- --scope=personal
nix run github:nhooey/data-skills#uninstall -- --scope=personal
```

`--scope` is required on every invocation; see the [`agent-skill-flake` install-scope docs](https://github.com/nhooey/agent-skill-flake#install-scope) for the resolver semantics.

## Dev shell

`nix develop` installs the skills used to work on this repo, at project scope, into `<repo-root>/.agents/skills/`, with `.claude/skills` a symlink to it. The set comes from the `skills-devshell/` sub-flake: skillspkgs' [`authoring-with-git`](https://github.com/nhooey/skillspkgs) combination (nix, humanizer, skill-creation, superpowers and the whole git/GitHub pack), [`shell-skills`](https://github.com/nhooey/shell-skills), and three skills from [`coding-agent-skills`](https://github.com/nhooey/coding-agent-skills). This repo's own `data-comparison-tables` isn't among them. The set is converged on shell entry: missing skills are installed, changed ones updated, and renamed or dropped ones swept.

The shell's commands:

- `check`: run `nix flake check`, which formats through treefmt, builds every skill, and checks each `SKILL.md`'s frontmatter `name` and `description`.
- `fmt`: format the tree with treefmt.
- `skills-dev`: this repository's own tool, in [`scripts/skills-dev.sh`](scripts/skills-dev.sh). `skills-dev build` builds every skill, or the ones named; `skills-dev lint` checks each `SKILL.md`'s frontmatter; `skills-dev test` runs the bats tests under `tests/`. `skills-dev --help` lists its commands and options.
- `update-flake`: update `flake.lock`.
- `update-skills-devshell`: update the `skills-devshell/` sub-flake's lock.
- `reap-skills`: remove every skill the dev shell installed.
