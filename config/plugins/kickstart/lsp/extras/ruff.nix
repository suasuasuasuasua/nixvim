{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "ruff";
  cfg = config.nixvim.lsp.languages.${name};
in
{
  options.nixvim.lsp.languages.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.ruff = {
        enable = true;
        # NOTE: add options as I need
      };

      conform-nvim.settings.formattersByFt =
        lib.mkIf config.nixvim.plugins.kickstart.conform-nvim.enable
          {
            # Use stop_after_first to run only the first available formatter
            python = {
              __unkeyed-1 = "black";
              __unkeyed-2 = "ruff";
              stop_after_first = true;
            };
          };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          python
        ];
    };

    extraPackages = with pkgs; [
      ruff
    ];
  };
}
