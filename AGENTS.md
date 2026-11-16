# data-skills

Agent skills for working with data, packaged as a Nix flake with
[`agent-skill-flake`](https://github.com/nhooey/agent-skill-flake). Each
skill is a directory under `skills/` holding its `SKILL.md`, and the
flake builds every one it finds there:

- `data-hygiene-figures-from-queries`: every figure stated comes from a
  command run on the data, named with the time of its data.
- `data-hygiene-measure-before-concluding`: repeated runs, a median and
  a spread before claiming one option beats another.
- `data-workflow-query-with-duckdb`: ad-hoc questions about data files go
  through one DuckDB query.
- `data-hygiene-dated-sourced-prices`: prices and specs carry a source,
  an ISO currency code and the date read.

## Build and test

- `nix develop`: enter the dev shell, which installs the skills it uses
  into `.agents/skills/` from the `skills-devshell/` sub-flake. The
  commands below are on its `PATH`; `menu` lists them.
- `check`: run `nix flake check`, formatting through treefmt among the
  checks. It must pass before a change merges.
- `fmt`: format the tree.
- `skills-dev`: this repository's own tool; `skills-dev --help` lists
  its commands. `skills-dev build` builds every skill, or the ones named;
  `skills-dev lint` checks each `SKILL.md`'s frontmatter; `skills-dev
  test` runs the bats tests under `tests/` on the working tree.
- `checks/` holds the scripts `nix flake check` runs on the skills,
  `scripts/` the `skills-dev` tool, and `tests/` the bats tests for both,
  which run in the same `nix flake check`.
