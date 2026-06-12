{ pkgs, ... }:
{
  plugins = {
    lsp.servers.tinymist = {
      enable = true;
      settings = {
        formatterMode = "typstyle";
        formatterProseWrap = true;
        formatterPrintWidth = 80;
        formatterIndentSize = 2;
      };
    };
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ typst ];
  };
}
