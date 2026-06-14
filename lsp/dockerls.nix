{ pkgs, ... }:
{
  plugins = {
    lsp.servers.dockerls.enable = true;
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ dockerfile ];
  };
}
