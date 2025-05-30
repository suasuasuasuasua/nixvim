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
    # You can easily change to a different colorscheme.
    # Add your colorscheme here and enable it.
    # Don't forget to disable the colorschemes you arent using
    #
    # If you want to see what colorschemes are already installed, you can use
    # `:Telescope colorscheme`.
    colorschemes = {
      # https://nix-community.github.io/nixvim/colorschemes/catppuccin/index.html
      catppuccin = {
        enable = cfg.colorscheme.name == "catppuccin";
        lazyLoad = lib.mkIf config.plugins.lz-n.enable {
          enable = true;
          settings = {
            colorscheme = "catppuccin";
          };
        };
        settings = {
          default_integrations = true;
          # one of “latte”, “mocha”, “frappe”, “macchiato”, “auto”
          flavour = "mocha";
        };
      };
      # https://nix-community.github.io/nixvim/colorschemes/everforest/index.html
      # * current
      everforest = {
        enable = cfg.colorscheme.name == "everforest";
        settings = {
          enable_italic = 1;
          # one of “hard”, “medium”, “soft”
          background = "hard";
        };
      };
      # https://nix-community.github.io/nixvim/colorschemes/tokyonight/index.html
      tokyonight = {
        enable = cfg.colorscheme.name == "tokyonight";
        lazyLoad = lib.mkIf config.plugins.lz-n.enable {
          enable = true;
          settings = {
            colorscheme = "tokyonight";
          };
        };
        settings = {
          # Like many other themes, this one has different styles, and you could
          # load any other, such as 'storm', 'moon', or 'day'.
          style = "night";
        };
      };
      # https://nix-community.github.io/nixvim/colorschemes/vscode/index.html
      vscode = {
        enable = cfg.colorscheme.name == "vscode";
        lazyLoad = lib.mkIf config.plugins.lz-n.enable {
          enable = true;
          settings = {
            colorscheme = "vscode";
          };
        };
        settings = {
          italic_comments = true;
          underline_links = true;
        };
      };
    };
  };
}
