{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "tmux";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/christoomey/vim-tmux-navigator
    plugins.tmux-navigator = {
      enable = true;
    };

    extraPlugins = with pkgs; [
      # https://github.com/aserowy/tmux.nvim
      vimPlugins.tmux-nvim
    ];

    plugins.lz-n = lib.mkIf config.plugins.lz-n.enable {
      # https://nix-community.github.io/nixvim/plugins/lz-n/plugins.html
      plugins = [
        {
          __unkeyed-1 = "tmux.nvim"; # the plugin's name (:h packadd)
          after =
            # lua
            ''
              function()
                require("tmux").setup()
              end
            '';
          event = [
            "DeferredUIEnter"
          ];
        }
      ];
    };
  };
}
