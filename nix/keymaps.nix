{
  # [[ Basic Keymaps ]]
  #  See `:help vim.keymap.set()`
  # https://nix-community.github.io/nixvim/keymaps/index.html
  keymaps = [
    # Clear highlights on search when pressing <Esc> in normal mode
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Disable search highlights";
    }

    # Open diagnostic quickfix list
    {
      mode = "n";
      key = "<leader>q";
      action.__raw = "vim.diagnostic.setloclist";
      options.desc = "Open diagnostic [Q]uickfix list";
    }

    # Move focus between panes
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options.desc = "Move focus to the left window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options.desc = "Move focus to the right window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options.desc = "Move focus to the lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options.desc = "Move focus to the upper window";
    }

    # Escape
    {
      mode = "i";
      key = "jk";
      action = "<Esc>";
    }
    {
      mode = "i";
      key = "Jk";
      action = "<Esc>";
    }
    {
      mode = "i";
      key = "jK";
      action = "<Esc>";
    }
    {
      mode = "i";
      key = "JK";
      action = "<Esc>";
    }

    # Make
    {
      mode = "n";
      key = "<Leader>mm";
      action = "<Cmd>make<CR>";
      options.desc = "[M]ake the project";
    }
  ];
}
