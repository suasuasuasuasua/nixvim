{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "yamlls";
  cfg = config.suasuasuasuasua.nixvim.lsp.${name};
in
{
  options.suasuasuasuasua.nixvim.lsp.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} LSP for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.yamlls = {
        enable = true;
        # NOTE: add options as I need
      };

      treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        yaml
      ];
    };
  };
}
