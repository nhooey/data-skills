{
  description = "agent-skills: every first-party Claude Code skill (git/GitHub hygiene, Nix, coding-agent workflow, comparison-tables) as one Nix flake — per-skill packages, origin-named packs, and a dev shell that dogfoods the whole set at project scope.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # `flake-skills` is the builder library, not a skill — it turns skill
    # directories into installable flakes and aggregates them. It is the only
    # nhooey input this repo takes: a skill repo never depends on a sibling or
    # a downstream aggregator, which is what keeps the consolidated graph
    # acyclic.
    flake-skills = {
      url = "github:nhooey/flake-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-parts,
      flake-skills,
      ...
    }@inputs:
    let
      # Every skill under ./skills built into per-skill packages (consumed by
      # `packs`/`mkEnv` below) plus the base install/preview/reconcile apps.
      # Skills are organized into origin groups (skills/git, skills/nix,
      # skills/coding-agent, skills/misc) and discovered recursively, so the
      # on-disk grouping is cosmetic — every package key stays the flat
      # `agent-skill-nhooey-<name>`.
      base = flake-skills.lib.mkAllSkillsFlake {
        inherit nixpkgs;
        source = import ./source.nix;
        skillsDir = ./skills;
        packagePrefix = "agent-skill-";
      };

      # Origin-named skill bundles. Each was previously the lone pack of a
      # separate repo (skills-git, skills-nix, coding-agent-skills); carried
      # forward under the same origin-unique keys so a downstream `//`-merge
      # (skillspkgs / nur-packages) never collides them. A pack list is bare
      # installed skill names; `base.bySkillName` indexes the per-skill drvs by
      # that stable identity.
      packs = {
        # ── git/GitHub (from skills-git) ──────────────────────────────────
        # All 11 git-* skills.
        agent-skills-git-all = [
          "git-hygiene-branch-naming"
          "git-hygiene-commit-message-format"
          "git-hygiene-conventional-commits"
          "git-hygiene-gitignore"
          "git-hygiene-no-history-in-code"
          "git-hygiene-push-force-safely"
          "git-hygiene-ssh-remotes"
          "git-workflow-cleanup-merged-branches"
          "git-workflow-curate-unpushed"
          "git-workflow-inspect-before-commit"
          "git-workflow-push-mode"
        ];

        # All git-hygiene-* skills: rules-of-thumb (commit/branch style,
        # safe force-push, SSH-by-default).
        agent-skills-git-hygiene = [
          "git-hygiene-branch-naming"
          "git-hygiene-commit-message-format"
          "git-hygiene-conventional-commits"
          "git-hygiene-gitignore"
          "git-hygiene-no-history-in-code"
          "git-hygiene-push-force-safely"
          "git-hygiene-ssh-remotes"
        ];

        # All git-workflow-* skills: interactive / multi-step procedures.
        agent-skills-git-workflow = [
          "git-workflow-cleanup-merged-branches"
          "git-workflow-curate-unpushed"
          "git-workflow-inspect-before-commit"
          "git-workflow-push-mode"
        ];

        # All 10 github-* skills (includes the agent-tagged trio).
        agent-skills-github-all = [
          "github-hygiene-gh-cli-gotchas"
          "github-hygiene-pull-request-mirrors-commit"
          "github-policy-auto-delete-merged-branches"
          "github-policy-codeowners"
          "github-policy-merge-commits-only"
          "github-policy-protect-default-branch"
          "github-pull-request-changeset-prompt"
          "github-pull-request-stacked"
          "github-pull-request-status-line"
          "github-pull-request-watcher"
        ];

        # All github-hygiene-* skills: PR-shape discipline + `gh` CLI gotchas.
        agent-skills-github-hygiene = [
          "github-hygiene-gh-cli-gotchas"
          "github-hygiene-pull-request-mirrors-commit"
        ];

        # All github-policy-* skills: one-time repo configuration.
        agent-skills-github-policy = [
          "github-policy-auto-delete-merged-branches"
          "github-policy-codeowners"
          "github-policy-merge-commits-only"
          "github-policy-protect-default-branch"
        ];

        # All github-pull-request-* skills: PR lifecycle / agent behavior.
        agent-skills-github-pull-request = [
          "github-pull-request-changeset-prompt"
          "github-pull-request-stacked"
          "github-pull-request-status-line"
          "github-pull-request-watcher"
        ];

        # ── nix (from skills-nix) ─────────────────────────────────────────
        agent-skills-nix-all = [
          "nix-clojure"
          "nix-flake-recursive-bump-input-versions"
          "nix-flakes"
          "nix-garnix-ci"
          "nix-java"
        ];

        # ── coding-agent (from coding-agent-skills) ───────────────────────
        agent-skills-coding-agent-all = [
          "coding-agent-keep-computer-awake"
          "coding-agent-questions-as-first-class-prompts"
          "coding-agent-route-feedback-to-skills-over-memory"
          "coding-agent-session-recap"
        ];
      };

      # Build a `flake-skills.lib.mkSkillsEnv` for one (packName, skillNames)
      # pair. The env keeps the same `nix run`/`nix build` UX as a plain
      # `symlinkJoin`, but also carries the `passthru.isFlakeSkillsEnv` +
      # `flakeSkillsEnv` records that `programs.flake-skills.skills` needs to
      # expand the env back into per-skill records on home-manager activation.
      # `base.bySkillName` indexes the per-skill drvs by bare installed name,
      # independent of the owner-namespaced package keys.
      mkEnv =
        system: packName: skillNames:
        flake-skills.lib.mkSkillsEnv {
          pkgs = nixpkgs.legacyPackages.${system};
          name = packName;
          skills = builtins.map (n: base.bySkillName.${system}.${n}) skillNames;
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.devshell.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      # Expose the declarative reconcile one-liner (system -> shell snippet at
      # --scope=project) so downstream consumers (skillspkgs) can install this
      # repo's git pack with the same idiom the aggregate flakes use.
      flake.reconcileScript = base.reconcileScript;

      perSystem =
        { system, ... }:
        {
          packages =
            base.packages.${system}
            // builtins.mapAttrs (packName: skillNames: mkEnv system packName skillNames) packs;

          apps = base.apps.${system};

          # Dogfood the full first-party set: reconcile every skill in this
          # repo at project scope on `nix develop`. `self` now *is* the whole
          # authoring set, so the install draws only from the local base — no
          # sibling or downstream source, no back-edge. The non-Nix authoring
          # meta-skills (skill-creator, superpowers, humanizer) deliberately
          # live downstream in skillspkgs, not here.
          devshells.default = {
            name = "agent-skills";
            motd = ''
              {bold}{14}🚀 Entering agent-skills dev shell{reset}
              Run {bold}menu{reset} to list available commands.
            '';
            devshell.startup.install-skills.text = ''
              ${base.reconcileScript system}
            '';
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              shfmt.enable = true;
              yamlfmt.enable = true;
            };
          };
        };
    };
}
