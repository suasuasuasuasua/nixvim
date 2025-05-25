{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "nil_ls";
  cfg = config.nixvim.lsp.${name};
in
{
  options.nixvim.lsp.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} LSP for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.nil_ls = {
        enable = true;
        # NOTE: add options as I need
      };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          nix
        ];
    };
  };
}
