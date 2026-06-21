-- disable highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Disable search highlights' })

-- open diagnostic list
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- move focus between panes
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- escape
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('i', 'jK', '<Esc>')
vim.keymap.set('i', 'Jk', '<Esc>')
vim.keymap.set('i', 'JK', '<Esc>')

-- make
vim.keymap.set('n', '<Leader>mm', '<Cmd>make<CR>', { desc = '[M]ake the project' })
