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

    # Persistent folding: save fold state when leaving a buffer
    {
      event = [
        "BufWinLeave"
        "BufWritePost"
        "WinLeave"
      ];
      desc = "Save fold state when leaving a buffer";
      callback.__raw =
        # lua
        ''
          function(args)
            if vim.b[args.buf].view_activated then pcall(vim.cmd.mkview) end
          end
        '';
    }

    # Persistent folding: restore fold state the first time a buffer is entered
    {
      event = [ "BufWinEnter" ];
      desc = "Restore fold state the first time a buffer is entered";
      callback.__raw =
        # lua
        ''
          function(args)
            if not vim.b[args.buf].view_activated then
              local buftype = vim.bo[args.buf].buftype
              local filetype = vim.bo[args.buf].filetype
              if buftype == '' and filetype ~= '' then
                vim.b[args.buf].view_activated = true
                pcall(vim.cmd.loadview)
              end
            end
          end
        '';
    }
  ];
}
