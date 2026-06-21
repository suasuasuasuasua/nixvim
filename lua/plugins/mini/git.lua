local diff = require 'mini.diff'
diff.setup {
  view = {
    style = 'sign',
    signs = { add = '+', change = '~', delete = '_' },
  },
}

vim.keymap.set('n', '<leader>hp', diff.toggle_overlay, { desc = 'git [p]review hunk (overlay)' })

require('mini.git').setup()
local align_blame = function(au_data)
  if au_data.data.git_subcommand ~= 'blame' then return end

  -- Align blame output with source
  local win_src = au_data.data.win_source
  vim.wo.wrap = false
  vim.fn.winrestview { topline = vim.fn.line('w0', win_src) }
  vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0 })

  -- Bind both windows so that they scroll together
  vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
end

local au_opts = { pattern = 'MiniGitCommandSplit', callback = align_blame }
vim.api.nvim_create_autocmd('User', au_opts)
vim.keymap.set({ 'n', 'x' }, '<leader>hb', '<cmd>vert Git blame -- %<CR>', { desc = 'git [b]lame line / show at cursor' })
vim.keymap.set('n', '<leader>hd', '<cmd>Git diff --cached -- %<CR>', { desc = 'git [d]iff against index' })
vim.keymap.set('n', '<leader>hD', '<cmd>Git diff HEAD -- %<CR>', { desc = 'git [D]iff against last commit' })
vim.keymap.set({ 'n', 'x' }, '<Leader>hs', '<cmd>lua MiniGit.show_at_cursor()<CR>', { desc = 'Show at cursor' })
