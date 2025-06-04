{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "yamlls";
  cfg = config.nixvim.lsp.languages.${name};
in
{
  options.nixvim.lsp.languages.${name} = {
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

      conform-nvim.settings.formattersByFt =
        lib.mkIf config.nixvim.plugins.kickstart.conform-nvim.enable
          {
            yamlls = [ "yamlfmt" ];
          };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          yaml
        ];
    };

    extraPackages = with pkgs; [
      yamlfmt
    ];
  };
}
