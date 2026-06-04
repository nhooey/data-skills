{
  description = "agent-skills: Agent skills as a Nix flake — the comparison-tables skill, plus a dev shell that installs git/github + skillspkgs authoring tooling at project scope.";

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
    # directories into installable flakes and aggregates them.
    flake-skills = {
      url = "github:nhooey/flake-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dev-shell-only skill source: skillspkgs' curated `authoring-with-git`
    # combination (the authoring set — nix, humanizer, anthropic + daymade
    # skill-creation, superpowers — plus the whole git/GitHub pack). Installs
    # into the dev shell at project scope; not re-exported as a package.
    skillspkgs-combinations = {
      url = "github:nhooey/skillspkgs?dir=sources/combinations";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-skills.follows = "flake-skills";
      };
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      flake-skills,
      ...
    }:
    let
      # The skills this repo outputs: every skill under ./skills built into
      # per-skill packages plus the base install/preview apps. The dev-shell
      # skills are kept separate (see `devShellSkills`).
      base = flake-skills.lib.mkAllSkillsFlake {
        inherit nixpkgs;
        source = {
          owner = "nhooey";
        };
        skillsDir = ./skills;
        packagePrefix = "agent-skill-";
      };

      # The dev shell's full skill set as one combination: this repo's own
      # skills (dogfooded) plus skillspkgs' `authoring-with-git` combination
      # (authoring tooling + the whole git/GitHub pack) spliced in as a source.
      # One reconcile hook converges the union under one owner.
      devShellSkills = flake-skills.lib.mkCombination {
        inherit nixpkgs;
        systems = import inputs.systems;
        name = "agent-skills-devshell";
        packagePrefix = "agent-skill-";
        sources = [
          { source = base; }
          { source = inputs.skillspkgs-combinations.combinations.authoring-with-git; }
        ];
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.devshell.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        { system, ... }:
        {
          packages = base.packages.${system};
          apps = base.apps.${system};

          devshells.default = {
            name = "agent-skills";
            motd = ''
              {bold}{14}🚀 Entering agent-skills dev shell{reset}
              Run {bold}menu{reset} to list available commands.
            '';
            # Declarative convergence: install missing, update changed, and
            # sweep skills a source renamed or dropped — a pure function of
            # the flake inputs, owned by a single combined installer.
            devshell.startup.install-skills.text = devShellSkills.reconcileScript system;
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            programs.shfmt.enable = true;
            programs.yamlfmt.enable = true;
          };
        };
    };
}
