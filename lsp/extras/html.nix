{ pkgs, ... }:
{
  plugins = {
    lsp.servers.html.enable = true;
    conform-nvim.settings.formattersByFt.html = [ "prettierd" ];
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ html ];
  };

  extraPackages = [ pkgs.prettierd ];
}
