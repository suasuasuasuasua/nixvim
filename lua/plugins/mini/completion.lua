require('mini.cmdline').setup()
require('mini.completion').setup {
  delay = { completion = 10, info = 10, signature = 5 },
}
