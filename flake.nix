{
  description = "suasuasuasuasua's nixvim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
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
            module = import ./.; # import the module directly
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
          pre-commit.settings = {
            hooks = {
              treefmt = {
                enable = true;
                # add the packages so the precommit-hook treefmt can find them
                settings.formatters = with pkgs; [
                  nixfmt
                  prettier
                ];
              };
              deadnix.enable = true;
              flake-checker.enable = false;
              statix.enable = true;
              commitizen.enable = true;
              ripsecrets.enable = true;
              check-added-large-files.enable = true;
              check-merge-conflicts.enable = true;
              end-of-file-fixer.enable = true;
              trim-trailing-whitespace.enable = true;
            };
            package = pkgs.prek;
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
