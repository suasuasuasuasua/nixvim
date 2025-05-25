{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "bashls";
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
      lsp.servers.bashls = {
        enable = true;
        # NOTE: add options as I need
      };

      treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
      ];
    };
  };
}
