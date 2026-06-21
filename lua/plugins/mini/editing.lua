require('mini.ai').setup()
require('mini.bracketed').setup()
require('mini.jump').setup {
  delay = { highlight = 10 },
}
require('mini.move').setup()
require('mini.pairs').setup {
  modes = { command = true },
}
require('mini.splitjoin').setup()
require('mini.trailspace').setup()

require('mini.misc').setup()
MiniMisc.setup_auto_root()

require('mini.surround').setup {
  mappings = {
    add = 'ys',
    delete = 'ds',
    find = '',
    find_left = '',
    highlight = '',
    replace = 'cs',

    suffix_last = '',
    suffix_next = '',
  },
  search_method = 'cover_or_next',
}
vim.keymap.del('x', 'ys')
vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
vim.keymap.set('n', 'yss', 'ys_', { remap = true })

local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup {
  snippets = {
    gen_loader.from_lang(),
  },
}
