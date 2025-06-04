{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "nixd";
  cfg = config.nixvim.lsp.languages.${name};
in
{
  options.nixvim.lsp.languages.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} LSP for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.nixd = {
        enable = true;
        # NOTE: add options as I need
        settings = {
          nixpkgs = {
            # For flake.
            # "expr": "import (builtins.getFlake \"/home/lyc/workspace/CS/OS/NixOS/flakes\").inputs.nixpkgs { }   "

            # This expression will be interpreted as "nixpkgs" toplevel
            # Nixd provides package, lib completion/information from it.
            #
            # Resource Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
            #                Package documentation, versions, are evaluated by-need.
            expr = "import <nixpkgs> { }";
          };
          # TODO: figure out how to include nixos and home configurations
          # completion :(
          # Tell the language server your desired option set, for completion
          # This is lazily evaluated.
          options = {
            # Map of eval information
            # If this is omitted, default search path (<nixpkgs>) will be used.
            nixos = {
              expr =
                # nix
                ''
                  (builtins.getFlake (builtins.toString ./.)).nixosConfigurations."lab".options;
                '';
            };
            darwin = {
              expr =
                # nix
                ''
                  (builtins.getFlake (builtins.toString ./.)).darwinConfigurations."mbp3".options;
                '';
            };
            home-manager = {
              expr =
                # nix
                ''
                  (builtins.getFlake (builtins.toString ./.)).nixosConfigurations."lab".options.home-manager.users.type.getSubOptions []
                '';
            };
          };
        };
      };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          nix
        ];
    };
  };
}
