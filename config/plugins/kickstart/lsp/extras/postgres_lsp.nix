{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "postgres_lsp";
  cfg = config.nixvim.lsp.languages.${name};
in
{
  options.nixvim.lsp.languages.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.postgres_lsp = {
        enable = true;
        # NOTE: add options as I need
      };

      conform-nvim.settings.formattersByFt =
        lib.mkIf config.nixvim.plugins.kickstart.conform-nvim.enable
          {
            sql = [ "sqlfluff" ];
          };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          sql
        ];
    };

    extraPackages = with pkgs; [
      sqlfluff
    ];
  };
}
