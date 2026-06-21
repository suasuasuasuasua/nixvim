require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
MiniIcons.tweak_lsp_kind()

require('mini.input').setup()
require('mini.notify').setup()

local indentscope = require 'mini.indentscope'
indentscope.setup {
  draw = {
    delay = 10,
    animation = indentscope.gen_animation.none(),
  },
}

local hipatterns = require 'mini.hipatterns'
hipatterns.setup {
  highlighters = {
    fixme     = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
    hack      = { pattern = 'HACK', group = 'MiniHipatternsHack' },
    todo      = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
    note      = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}

require('mini.statusline').setup()

require('mini.cursorword').setup {
  delay = 10,
}
