{ pkgs, ... }:
{
  plugins = {
    lsp.servers.sqls.enable = true;
    conform-nvim.settings.formattersByFt.sql = [ "sqlfluff" ];
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ sql ];
  };

  extraPackages = [ pkgs.sqlfluff ];
}
