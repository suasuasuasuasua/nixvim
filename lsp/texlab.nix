{ pkgs, ... }:
{
  plugins = {
    lsp.servers.texlab.enable = true;
    conform-nvim.settings.formattersByFt.tex = [ "tex-fmt" ];
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ latex ];
  };

  extraPackages = [ pkgs.tex-fmt ];
}
