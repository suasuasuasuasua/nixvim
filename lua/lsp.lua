-- LSP servers on $PATH via Nix (lspsAndRuntimeDeps in flake.nix)
-- To add tinymist: append 'tinymist' to the list and ensure typst category is enabled
vim.lsp.enable {
  'clangd',
  'gopls',
  'lua_ls',
  'nil_ls',
  'pylsp',
}

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines
}
