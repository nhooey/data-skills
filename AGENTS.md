# data-skills

Agent skills for working with data, packaged as a Nix flake with
[`agent-skill-flake`](https://github.com/nhooey/agent-skill-flake). Each
skill is a directory under `skills/` holding its `SKILL.md`.

## Build and test

- `nix develop`: enter the dev shell, which installs the skills it uses
  into `.agents/skills/` from the `skills-devshell/` sub-flake.
- `nix build .#agent-skills-nhooey-data-all`: build every skill.
- `nix flake check`: run the checks, formatting through treefmt among
  them. It must pass before a change merges.
- `nix fmt`: format the tree.
