{
  description = "Felipe Pinto's nixvim config";

  inputs = {
    # main
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";

    # utility
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixvim,
      systems,
      flake-parts,
      ...
    }@inputs:
    # TODO: move away from flake-parts
    # I think it's super convenient, but I don't like the idea of tying myself
    # to some nix framework that is still experimental. Ideally, I would just
    # implement this all in native nix and flake module syntax. I am going with
    # it now to move fast since it was included in the template
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      imports = [
        # Import nixvim's flake-parts module;
        # Adds `flake.nixvimModules` and `perSystem.nixvimConfigurations`
        nixvim.flakeModules.default
      ];

      nixvim = {
        # Automatically install corresponding packages for each nixvimConfiguration
        # Lets you run `nix run .#<name>`, or simply `nix run` if you have a default
        packages.enable = true;
        # Automatically install checks for each nixvimConfiguration
        # Run `nix flake check` to verify that your config is not broken
        checks.enable = true;
      };

      # You can define your reusable Nixvim modules here
      flake = {
        nixosModules.default = import ./config;
        darwinModules.default = import ./config;

        nixvimModules = {
          default = ./config;
        };
      };

      perSystem =
        { pkgs, system, ... }:
        {
          formatter = pkgs.nixfmt-rfc-style;

          # You can define actual Nixvim configurations here
          nixvimConfigurations = {
            default = nixvim.lib.evalNixvim {
              inherit system;
              modules = [ self.nixvimModules.default ];
            };
          };
        };
    };
}
