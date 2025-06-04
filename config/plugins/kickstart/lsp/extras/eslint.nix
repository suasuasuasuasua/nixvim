{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "eslint";
  cfg = config.nixvim.lsp.languages.${name};
in
{
  options.nixvim.lsp.languages.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.eslint = {
        enable = true;
        # NOTE: add options as I need
      };

      conform-nvim.settings.formattersByFt =
        lib.mkIf config.nixvim.plugins.kickstart.conform-nvim.enable
          {
            javascript = [ "eslint_d" ];
          };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          javascript
          typescript
        ];
    };

    extraPackages = with pkgs; [
      eslint_d
    ];
  };
}
