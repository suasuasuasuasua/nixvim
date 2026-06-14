{ pkgs, ... }:
{
  # https://github.com/MagicDuck/grug-far.nvim/
  plugins.grug-far = {
    enable = true;

    # NOTE: lazy loading by default
  };

  extraPackages = [ pkgs.ast-grep ];
}
