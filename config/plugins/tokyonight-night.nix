{
  config,
  lib,
  ...
}:
let
  cfg = config.nixvim;

  inherit (lib.types) bool enum;
in
{
  options.nixvim = {
    colorscheme = {
      enable = lib.mkOption {
        type = bool;
        default = true;
        description = "Enable colorschemes for Neovim";
      };
      name = lib.mkOption {
        type = enum [
          "catppuccin"
          "everforest"
          "tokyonight"
          "vscode"
        ];
        default = "tokyonight";
      };
    };
  };

  config = lib.mkIf cfg.colorscheme.enable {
    colorschemes = {
      # https://nix-community.github.io/nixvim/colorschemes/catppuccin/index.html
      catppuccin = {
        enable = cfg.colorscheme.name == "catppuccin";
        settings = {
          default_integrations = true;
          flavour = "mocha";
        };
      };

      # https://nix-community.github.io/nixvim/colorschemes/everforest/index.html
      everforest = {
        enable = cfg.colorscheme.name == "everforest";
        settings = {
          enable_italic = 1;
          background = "hard";
        };
      };

      # https://nix-community.github.io/nixvim/colorschemes/tokyonight/index.html
      tokyonight = {
        enable = cfg.colorscheme.name == "tokyonight";
        settings = {
          style = "night";
          styles = {
            comments = {
              italic = false;
            };
          };
        };
      };

      # https://nix-community.github.io/nixvim/colorschemes/vscode/index.html
      vscode = {
        enable = cfg.colorscheme.name == "vscode";
        settings = {
          italic_comments = true;
          underline_links = true;
        };
      };
    };
  };
}
