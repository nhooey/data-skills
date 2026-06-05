# agent-skills

[![built with garnix](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fnhooey%2Fagent-skills)](https://garnix.io/repo/nhooey/agent-skills)

A Nix flake packaging the [`comparison-tables`](skills/comparison-tables/SKILL.md) [Agent Skill](https://www.anthropic.com/engineering/agent-skills) — guidance for writing scannable Markdown comparison tables — plus a dev shell that installs a curated skill-authoring toolkit at project scope.

Skills are built and installed with [`agent-skill-flake`](https://github.com/nhooey/agent-skill-flake).

## The skill

- **`comparison-tables`** — when writing a Markdown document that compares two or more concrete things (products, libraries, services, frameworks, …), shape it as a table a reader can scan in seconds: items in rows, properties in columns, binary values as ✅/❌, hyperlinked names, and uniform properties pulled out into a list beneath.

## Install

```sh
# install comparison-tables at personal scope (~/.claude/skills/)
nix run github:nhooey/agent-skills#install -- --scope=personal

# or at project scope (<repo-root>/.claude/skills/)
nix run github:nhooey/agent-skills#install -- --scope=project

# preview / remove
nix run github:nhooey/agent-skills#preview   -- --scope=personal
nix run github:nhooey/agent-skills#uninstall -- --scope=personal
```

`--scope` is required on every invocation; see the [`agent-skill-flake` install-scope docs](https://github.com/nhooey/agent-skill-flake#install-scope) for the resolver semantics.

## Dev shell

`nix develop` reconciles this repo's own skill plus skillspkgs' [`authoring-with-git`](https://github.com/nhooey/skillspkgs) combination — the authoring toolkit (nix, humanizer, skill-creation, superpowers) plus the whole git/GitHub pack — into `<repo-root>/.claude/skills/` at project scope. The set is converged declaratively on shell entry: skills missing are installed, changed ones updated, and renamed or dropped ones swept.
