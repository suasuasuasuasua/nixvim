{
  lib,
  config,
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
      keymaps = [
        {
          action = "left";
          key = "<C-h>";
          options = {
            desc = "Tmux Navigate Left";
          };
        }
        {
          action = "down";
          key = "<C-j>";
          options = {
            desc = "Tmux Navigate Down";
          };
        }
        {
          action = "up";
          key = "<C-k>";
          options = {
            desc = "Tmux Navigate Up";
          };
        }
        {
          action = "right";
          key = "<C-l>";
          options = {
            desc = "Tmux Navigate Right";
          };
        }
        {
          action = "previous";
          key = "<C-\\>";
          options = {
            desc = "Tmux Navigate Previous";
          };
        }
      ];
      settings = {
        # rebind to give descriptions
        no_mappings = 1;
      };
    };
  };
}
