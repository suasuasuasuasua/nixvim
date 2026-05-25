{
  description = "suasuasuasuasua's nixvim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # TODO: undo when 0.12 comes out
    nixvim = {
      url = "github:nix-community/nixvim/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.git-hooks-nix.flakeModule ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      flake = {
        hydraJobs = {
          inherit (self) packages;
        };
        meta = {
          description = "My nixvim configuration";
          homepage = "https://github.com/suasuasuasuasua/nixvim";
          license = with nixpkgs.lib.licenses; [
            mit
          ];
          maintainers = [
            {
              name = "Justin Hoang";
              email = "justinhoang@sua.dev";
              github = "suasuasuasuasua";
              githubId = 72476123;
            }
          ];
        };
      };

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
                prettier
              ];
            };

            deadnix.enable = true; # remove any unused variabes and imports
            flake-checker.enable = false; # run `flake check`
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
                # Disable EVERYTHING
                "plain"
                # Disable all configurations (lsps, plugins, etc.)
                "minimal"
                # The default configuration has the essential configuration and
                # a few essential custom plugins
                "default"
              ];

        };
    };
}
