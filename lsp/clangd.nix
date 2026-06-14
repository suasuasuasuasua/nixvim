{ pkgs, ... }:
{
  plugins = {
    lsp.servers.clangd.enable = true;
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        c
        cpp
        printf
      ];
  };
}
