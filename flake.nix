{
  description = "suasuasuasuasua's nixvim config";

  inputs = {
    # use the latest stable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixvim,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.git-hooks-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # https://github.com/nix-community/nixvim/blob/1c5c991fda4519db56c30c9d75ba29ba7097af83/templates/simple/flake.nix
      perSystem =
        {
          lib,
          config,
          system,
          ...
        }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate =
              pkg:
              builtins.elem (lib.getName pkg) [
                "obsidian"
              ];
          };

          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit pkgs; # or alternatively, set `system`
            module = import ./config; # import the module directly
            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = {
              # inherit (inputs) foo;
            };
          };
          nvim = nixvim'.makeNixvimWithModule nixvimModule;
        in
        {
          devShells.default = import ./shell.nix {
            inherit pkgs config;
          };

          # enable treefmt as the formatter
          pre-commit.settings.hooks = {
            treefmt.enable = true;

            deadnix.enable = true; # remove any unused variabes and imports
            flake-checker = {
              enable = true; # run `flake check`
              package = pkgs.flake-checker;
            };
            statix.enable = true; # check "good practices" for nix

            commitizen.enable = true;
            ripsecrets.enable = true;

            # General
            check-added-large-files.enable = true; # warning about large files (lfs?)
            check-merge-conflicts.enable = true; # don't commit merge conflicts
            end-of-file-fixer.enable = true; # add a line at the end of the file
            trim-trailing-whitespace.enable = true; # trim trailing whitespace
          };
          formatter = pkgs.treefmt;

          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          };

          packages = {
            # Lets you run `nix run .` to start nixvim
            default = nvim;
          };
        };
    };
}
