{ pkgs, ... }:
{
  plugins = {
    lsp.servers.postgres_lsp.enable = true;
    conform-nvim.settings.formattersByFt.sql = [ "sqlfluff" ];
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ sql ];
  };

  extraPackages = [ pkgs.sqlfluff ];
}
