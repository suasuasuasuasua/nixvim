{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "sqls";
  cfg = config.nixvim.lsp.languages.${name};
in
{
  options.nixvim.lsp.languages.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.sqls = {
        enable = true;
        # NOTE: add options as I need
      };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          sql
        ];
    };
  };
}
