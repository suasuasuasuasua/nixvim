{ pkgs, ... }:
{
  plugins = {
    lsp.servers.rust_analyzer = {
      enable = true;
      installCargo = false;
      installRustc = false;
    };
    conform-nvim.settings.formattersByFt.rust = [ "rustfmt" ];
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ rust ];
  };

  extraPackages = [ pkgs.rustfmt ];
}
