{
  # https://github.com/christoomey/vim-tmux-navigator
  # (matches dotfiles' nvim-tmux-navigation behavior: C-h/j/k/l across tmux panes + nvim splits)
  plugins.tmux-navigator = {
    enable = true;
    settings = {
      # Disable when pane is zoomed (matches dotfiles disable_when_zoomed = true)
      disable_when_zoomed = 1;
    };
  };
}
