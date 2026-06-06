{
  description = "data-skills: Agent skills as a Nix flake — the data-comparison-tables skill, plus a dev shell that installs the skillspkgs authoring tooling at project scope.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # `agent-skill-flake` is the builder library, not a skill — it turns skill
    # directories into installable flakes and aggregates them, and exports the
    # `flakeModules.devshellSkills` flake-parts module that wires the dev-shell
    # skill set in below. That module bundles numtide/devshell, so this flake
    # needs no `devshell` input of its own.
    agent-skill-flake = {
      url = "github:nhooey/agent-skill-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      agent-skill-flake,
      ...
    }:
    let
      # The skills this repo outputs: every skill under ./skills built into
      # per-skill packages plus the base install/preview apps.
      base = agent-skill-flake.lib.mkAllSkillsFlake {
        inherit nixpkgs;
        source = {
          owner = "nhooey";
        };
        skillsDir = ./skills;
        packagePrefix = "agent-skill-";
        # Each skill dir already carries the `data-` topic prefix
        # (e.g. `data-comparison-tables`), so per-skill keys read
        # `agent-skill-nhooey-data-<name>`. The aggregate key derives from the
        # owner namespace alone, so name it explicitly to match the sibling
        # repos' `agent-skills-nhooey-<topic>-all` convention.
        name = "agent-skills-nhooey-data-all";
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        # Bundles numtide/devshell + the whole dev-shell skills convention
        # (motd, install-skills startup that reconciles the runtime
        # `skills-devshell/` sub-flake, the ci/dev/maintenance command trio, and
        # the reap-skills/update-skills-devshell pair). Configured via the
        # `agent-skill-flake.devshellSkills` options block below.
        inputs.agent-skill-flake.flakeModules.devshellSkills
        inputs.treefmt-nix.flakeModule
      ];

      # data-skills keeps the stock banner; omitting `motd` lets the module
      # regenerate the identical "🚀 Entering data-skills dev shell …" text
      # from `name`.
      agent-skill-flake.devshellSkills.name = "data-skills";

      perSystem =
        { system, ... }:
        {
          packages = base.packages.${system};
          apps = base.apps.${system};

          # The devshellSkills module (imported above) supplies this devShell's
          # name, motd, the install-skills startup, the ci/dev/maintenance
          # command trio, and the skills commands. data-skills adds nothing
          # repo-specific here.
          devshells.default = { };

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.shfmt.enable = true;
            programs.yamlfmt.enable = true;
          };
        };
    };
}
