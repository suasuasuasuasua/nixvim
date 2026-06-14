{ pkgs, ... }:
{
  plugins = {
    lsp.servers.nil_ls.enable = true;
    conform-nvim.settings.formattersByFt.nix = [ "nixfmt" ];
    treesitter.grammarPackages =
      with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [ nix ];
  };

  extraPackages = [ pkgs.nixfmt ];
}
