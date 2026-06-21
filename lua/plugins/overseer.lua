require('overseer').setup()

vim.keymap.set('n', '<Leader>oo', '<Cmd>OverseerOpen<CR>', { desc = '[O]pen [O]verseer' })
vim.keymap.set('n', '<Leader>or', '<Cmd>OverseerRun<CR>', { desc = '[O]verseer [R]un' })
vim.keymap.set('n', '<Leader>ot', '<Cmd>OverseerToggle<CR>', { desc = '[O]verseer [T]oggle' })

vim.api.nvim_create_user_command('Make', function(params)
  local cmd, num_subs = vim.o.makeprg:gsub('%$%*', params.args)
  if num_subs == 0 then cmd = cmd .. ' ' .. params.args end

  local task = require('overseer').new_task {
    cmd = vim.fn.expandcmd(cmd),
    components = {
      {
        'on_output_quickfix',
        open = not params.bang,
        open_height = 8,
        errorformat = vim.o.errorformat,
      },
      'default',
    },
  }
  task:start()
end, {
  desc = 'Run your makeprg as an Overseer task',
  nargs = '*',
  bang = true,
})
