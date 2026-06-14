{ pkgs, ... }:
{
  plugins = {
    lsp.servers.docker_compose_language_service.enable = true;
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ dockerfile ];
  };
}
