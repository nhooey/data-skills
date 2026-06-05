{
  description = "agent-skills: Agent skills as a Nix flake — the comparison-tables skill, plus a dev shell that installs the skillspkgs authoring tooling at project scope.";

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
    # `agent-skill-flake` is the builder library, not a skill — it turns skill
    # directories into installable flakes and aggregates them.
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
      };

      # Root-side wiring for the `skills-devshell/` sub-flake: the dev-shell
      # skill set (skillspkgs' authoring-with-git combination) is defined in
      # the isolated `skills-devshell/` sub-flake and invoked here at RUNTIME
      # (not a root input), so this flake keeps zero skill inputs and never
      # drags the skill mesh into its lock.
      devshellSkills = agent-skill-flake.lib.devshellSkillsHook { };
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
            # sweep skills a source renamed or dropped. Runs the reconcile app
            # from the `skills-devshell/` sub-flake at project scope.
            devshell.startup.install-skills.text = devshellSkills.startup;
            commands = devshellSkills.commands;
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
