{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "tailwindcss";
  cfg = config.nixvim.lsp.languages.${name};
in
{
  options.nixvim.lsp.languages.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lsp.servers.tailwindcss = {
        enable = true;
        # NOTE: add options as I need
      };

      conform-nvim.settings.formattersByFt =
        lib.mkIf config.nixvim.plugins.kickstart.conform-nvim.enable
          {
            # Use stop_after_first to run only the first available formatter
            css = {
              __unkeyed-1 = "css_beautify";
              __unkeyed-2 = "rustywind";
              stop_after_first = true;
            };
          };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          css
        ];
    };

    extraPackages = with pkgs; [
      rustywind
    ];
  };
}
