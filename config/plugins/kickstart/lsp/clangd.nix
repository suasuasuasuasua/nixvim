{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "clangd";
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
      lsp.servers.clangd = {
        enable = true;
      };

      treesitter.grammarPackages =
        with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          c
          cpp
          printf
        ];
    };

    extraPackages = with pkgs; [
      clang-tools
    ];

    keymaps = [
      {
        mode = "n";
        key = "<M-o>";
        action = "<cmd>LspClangdSwitchSourceHeader<CR>";
        options.desc = "Switch between source and header";
      }
    ];
  };
}
