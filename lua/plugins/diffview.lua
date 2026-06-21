require("diffview").setup()

-- Resolve origin's default branch, fall back to origin/main
local default_branch = vim.fn.systemlist("git symbolic-ref --short refs/remotes/origin/HEAD")[1]
if vim.v.shell_error ~= 0 or not default_branch or default_branch == "" then
  default_branch = "origin/main"
end

vim.keymap.set('n', '<Leader>do', '<CMD>DiffviewOpen<CR>', { desc = 'Show Diffview UI' })
vim.keymap.set('n', '<Leader>dom', '<CMD>DiffviewOpen ' .. default_branch .. '...HEAD<CR>',
  { desc = 'Show Diffview UI Relative to Main' })
vim.keymap.set('n', '<Leader>dh', '<CMD>DiffviewFileHistory<CR>', { desc = 'Show Diffview File History UI' })
vim.keymap.set('n', '<Leader>df', '<CMD>DiffviewFileHistory %<CR>',
  { desc = 'Show Diffview File History UI on current file' })
vim.keymap.set('n', '<Leader>dhm', '<CMD>DiffviewFileHistory --range=' .. default_branch .. '..HEAD<CR>',
  { desc = 'Show Diffview File History UI Relative to Main' })
