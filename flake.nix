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
            treefmt = {
              enable = true;
              # add the packages so the precommit-hook treefmt can find them
              settings.formatters = with pkgs; [
                nixfmt-rfc-style
                nodePackages.prettier
              ];
            };

            deadnix.enable = true; # remove any unused variabes and imports
            flake-checker = {
              enable = true; # run `flake check`
              # TODO: remove when v0.2.6 hits main nixpkgs
              # https://discourse.nixos.org/t/nixpkgs-overlay-for-mpd-discord-rpc-is-no-longer-working/59982
              package = pkgs.flake-checker.overrideAttrs rec {
                pname = "flake-checker";
                version = "0.2.6";

                src = pkgs.fetchFromGitHub {
                  owner = "DeterminateSystems";
                  repo = "flake-checker";
                  rev = "v0.2.6";
                  hash = "sha256-qEdwtyk5IaYCx67BFnLp4iUN+ewfPMl/wjs9K4hKqGc=";
                };
                cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
                  inherit src;
                  hash = "sha256-5eaVjrAPxBQdG+LQ6mQ/ZYAdslpdK3mrZ5Vbuwe3iQw=";
                };
              };
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

          # Lets you run `nix run .` to start nixvim
          packages =
            builtins.foldl'
              (
                acc: profile:
                {
                  ${profile} = import ./packages/${profile}.nix {
                    inherit nvim lib;
                  };
                }
                // acc
              )
              { }
              # in order of plugin and configuration complexity
              [
                # Disable EVERYTHING (kickstart and custom)
                "plain"
                # Disable all configurations (lsps, plugins, etc.)
                "minimal"
                # The default configuration has the kickstart configuration and
                # a few essential custom plugins
                "default"
                # Enable all configurations (lsps, plugins, etc.)
                # WARNING: some plugins require additional configuration, so make
                # sure to `.extend` the derivation that you choose appropriately
                # - `obsidian.nvim` needs workspaces for example
                "full"
              ];
        };
    };
}
