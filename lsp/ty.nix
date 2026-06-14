{ pkgs, ... }:
{
  plugins = {
    lsp.servers.ty.enable = true;
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ python ];
  };
}
