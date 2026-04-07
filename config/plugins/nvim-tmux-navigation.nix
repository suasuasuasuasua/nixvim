{
  lib,
  config,
  ...
}:
let
  name = "nvim-tmux-navigation";
  cfg = config.nixvim.plugins.${name};
in
{
  options.nixvim.plugins.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/christoomey/vim-tmux-navigator
    # (matches dotfiles' nvim-tmux-navigation behavior: C-h/j/k/l across tmux panes + nvim splits)
    plugins.tmux-navigator = {
      enable = true;
      settings = {
        # Disable when pane is zoomed (matches dotfiles disable_when_zoomed = true)
        disable_when_zoomed = 1;
      };
    };
  };
}
