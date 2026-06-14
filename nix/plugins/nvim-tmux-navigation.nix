{
  # https://github.com/christoomey/vim-tmux-navigator
  # dotfiles use alexghergh/nvim-tmux-navigation (not in nixpkgs); christoomey covers C-h/j/k/l/<C-\>
  # <C-Space> (next split) is alexghergh-specific and has no equivalent here
  plugins.tmux-navigator = {
    enable = true;
    settings.disable_when_zoomed = 1;
  };
}
