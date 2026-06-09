{
  # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
  autoGroups = {
    highlight-yank = {
      clear = true;
    };
  };

  # [[ Basic Autocommands ]]
  #  See `:help lua-guide-autocommands`
  # https://nix-community.github.io/nixvim/NeovimOptions/autoCmd/index.html
  autoCmd = [
    # Highlight when yanking (copying) text
    #  Try it with `yap` in normal mode
    #  See `:help vim.highlight.on_yank()`
    {
      event = [ "TextYankPost" ];
      desc = "Highlight when yanking (copying) text";
      group = "highlight-yank";
      callback.__raw =
        # lua
        ''
          function()
            vim.hl.on_yank()
          end
        '';
    }
  ];
}
