{ pkgs, ... }:
{
  plugins = {
    lsp.servers.cmake.enable = true;
    conform-nvim.settings.formattersByFt.cmake = [ "cmake_format" ];
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ cmake ];
  };

  extraPackages = [ pkgs.cmake-format ];
}
