# data-skills

A Nix flake for [Agent Skills](https://www.anthropic.com/engineering/agent-skills) about handling data honestly: figures that come from queries, comparisons that are measured, ad-hoc questions answered in DuckDB, and prices that carry a source and a date. It also has a dev shell that installs a curated skill-authoring toolkit at project scope.

Skills are built and installed with [`agent-skill-flake`](https://github.com/nhooey/agent-skill-flake).

## The skills

| Skill                                                                                                | What it does                                                                                                           |
| ---------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| [`data-hygiene-figures-from-queries`](skills/data-hygiene-figures-from-queries/SKILL.md)             | Every count, sum, rate or percentage comes from a command run on the data, named in the reply with the data's time.    |
| [`data-hygiene-measure-before-concluding`](skills/data-hygiene-measure-before-concluding/SKILL.md)   | Warm-up, repeated runs, median and spread before claiming one option is faster, smaller or cheaper.                    |
| [`data-workflow-query-with-duckdb`](skills/data-workflow-query-with-duckdb/SKILL.md)                 | Answer ad-hoc questions about CSV, JSON, NDJSON or Parquet files with one DuckDB query, shown with its answer.         |
| [`data-hygiene-dated-sourced-prices`](skills/data-hygiene-dated-sourced-prices/SKILL.md)             | Each price, spec or availability carries its source link, ISO currency code and date read; stale entries are marked.   |

Comparison tables are covered by [`writing-hygiene-tables-for-comparison`](https://github.com/nhooey/writing-skills), for when and what to compare, and [`markdown-hygiene-lists-headings-tables`](https://github.com/nhooey/document-skills), for the table's layout.

Package outputs: `agent-skills-nhooey-data-all`, the aggregate of every skill, and `agent-skill-nhooey-<skill>` for each skill above.

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

`nix develop` installs the skills used to work on this repo, at project scope, into `<repo-root>/.agents/skills/`, with `.claude/skills` a symlink to it. The set comes from the `skills-devshell/` sub-flake: skillspkgs' [`skill-collections`](https://github.com/nhooey/skillspkgs/blob/master/sources/combinations/families.nix) combination, the one shared by every skill collection, with no additions. The set is converged on shell entry: missing skills are installed, changed ones updated, and renamed or dropped ones swept.

The shell's commands:

- `check`: run `nix flake check`, which formats through treefmt, builds every skill, and checks each `SKILL.md`'s frontmatter `name` and `description`.
- `fmt`: format the tree with treefmt.
- `skills-dev`: this repository's own tool, in [`scripts/skills-dev.sh`](scripts/skills-dev.sh). `skills-dev build` builds every skill, or the ones named; `skills-dev lint` checks each `SKILL.md`'s frontmatter; `skills-dev test` runs the bats tests under `tests/`. `skills-dev --help` lists its commands and options.
- `update-flake`: update `flake.lock`.
- `update-skills-devshell`: update the `skills-devshell/` sub-flake's lock.
- `reap-skills`: remove every skill the dev shell installed.
