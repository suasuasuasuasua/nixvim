{ pkgs, ... }:
{
  plugins = {
    lsp.servers.nginx_language_server.enable = true;
    conform-nvim.settings.formattersByFt.nginx = [ "nginxfmt" ];
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ nginx ];
  };

  extraPackages = [ pkgs.nginx-config-formatter ];
}
