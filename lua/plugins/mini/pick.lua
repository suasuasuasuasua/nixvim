local pick = require 'mini.pick'
require('mini.extra').setup()
require('mini.visits').setup()
pick.setup()

-- Adding custom picker to pick `register` entries
pick.registry.registry = function()
  local items = vim.tbl_keys(pick.registry)
  table.sort(items)
  local source = { items = items, name = 'Registry', choose = function() end }
  local chosen_picker_name = pick.start { source = source }
  if chosen_picker_name == nil then return end
  return pick.registry[chosen_picker_name]()
end

-- Make `:Pick files` accept `cwd`
pick.registry.files = function(local_opts)
  local opts = { source = { cwd = local_opts.cwd } }
  local_opts.cwd = nil
  return MiniPick.builtin.files(local_opts, opts)
end

local builtin = pick.registry
vim.keymap.set('n', '<leader>sh', builtin.help, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', function() builtin.files { cwd = vim.fn.getcwd() } end, { desc = '[S]earch [N]eovim files' })
vim.keymap.set('n', '<leader>ss', function() MiniExtra.pickers.visit_paths() end, { desc = '[S]earch Recent Files (by visit frequency)' })
vim.keymap.set('n', '<leader>sg', builtin.grep_live, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostic, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.registry, { desc = '[S]earch [S]elect Registry' })
vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sn', function() builtin.files { cwd = vim.fn.resolve(vim.fn.stdpath 'config') } end, { desc = '[S]earch [N]eovim files' })
vim.keymap.set('n', '<leader>s:', function() builtin.history { scope = ':' } end, { desc = '[S]earch [N]eovim commands' })
vim.keymap.set('n', '<leader>s/', function() builtin.history { scope = '/' } end, { desc = '[S]earch [N]eovim search' })

-- https://nvim-mini.org/mini.nvim/doc/mini-extra.html#miniextra.pickers.lsp
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('minipick-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    vim.keymap.set('n', 'grr', function() builtin.lsp { scope = 'references' } end, { buffer = buf, desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gri', function() builtin.lsp { scope = 'implementation' } end, { buffer = buf, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', 'grd', function() builtin.lsp { scope = 'definition' } end, { buffer = buf, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gO', function() builtin.lsp { scope = 'document_symbol' } end, { buffer = buf, desc = 'Open Document Symbols' })
    vim.keymap.set('n', 'gW', function() builtin.lsp { scope = 'workspace_symbol' } end, { buffer = buf, desc = 'Open Workspace Symbols' })
    vim.keymap.set('n', 'grt', function() builtin.lsp { scope = 'type_definition' } end, { buffer = buf, desc = '[G]oto [T]ype Definition' })
  end,
})
