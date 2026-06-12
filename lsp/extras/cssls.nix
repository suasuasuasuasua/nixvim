{ pkgs, ... }:
{
  plugins = {
    lsp.servers.cssls.enable = true;
    conform-nvim.settings.formattersByFt.css = {
      __unkeyed-1 = "css_beautify";
      __unkeyed-2 = "rustywind";
      stop_after_first = true;
    };
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ css ];
  };

  extraPackages = [ pkgs.js-beautify ];
}
