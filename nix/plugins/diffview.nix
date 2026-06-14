{
  # https://github.com/sindrets/diffview.nvim
  plugins.diffview.enable = true;

  # Resolve origin's default branch dynamically at startup
  extraConfigLua =
    # lua
    ''
      local _diffview_default_branch = vim.fn.systemlist("git symbolic-ref --short refs/remotes/origin/HEAD")[1]
      if vim.v.shell_error ~= 0 or not _diffview_default_branch or _diffview_default_branch == "" then
        _diffview_default_branch = "origin/main"
      end

      vim.keymap.set('n', '<Leader>do', '<Cmd>DiffviewOpen<CR>', { desc = '[D]iff [O]pen' })
      vim.keymap.set('n', '<Leader>dom', '<Cmd>DiffviewOpen ' .. _diffview_default_branch .. '...HEAD<CR>',
        { desc = '[D]iff [O]pen against [M]ain' })
      vim.keymap.set('n', '<Leader>dh', '<Cmd>DiffviewFileHistory<CR>', { desc = '[D]iff file [H]istory' })
      vim.keymap.set('n', '<Leader>df', '<Cmd>DiffviewFileHistory %<CR>',
        { desc = '[D]iff current [F]ile history' })
      vim.keymap.set('n', '<Leader>dhm', '<Cmd>DiffviewFileHistory --range=' .. _diffview_default_branch .. '..HEAD<CR>',
        { desc = '[D]iff file history [M]ain' })
    '';
}
