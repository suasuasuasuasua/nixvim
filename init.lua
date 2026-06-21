vim.g.have_nerd_font = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.autoindent = true
vim.o.breakindent = true
vim.o.breakindentopt = 'list:-1'
vim.o.colorcolumn = '80'
vim.o.complete = '.,w,b,kspell'
vim.o.completeopt = 'menuone,popup,noinsert,noselect,fuzzy'
vim.o.completetimeout = 100
vim.o.confirm = true
vim.o.cursorline = true
vim.o.cursorlineopt = 'screenline,number'
vim.o.expandtab = true
vim.o.exrc = true
vim.o.foldcolumn = '1'
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldnestmax = 10
vim.o.foldtext = ''
vim.o.viewoptions = 'folds,cursor,curdir,slash,unix'
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.formatoptions = 'rqnl1j'
vim.o.ignorecase = true
vim.o.inccommand = 'split'
vim.o.incsearch = true
vim.o.infercase = true
vim.o.iskeyword = '@,48-57,_,192-255,-'
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:25,hor:6'
vim.o.number = true
vim.o.pumborder = 'single'
vim.o.pumheight = 10
vim.o.pummaxwidth = 100
vim.o.ruler = false
vim.o.scrolloff = 10
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.shortmess = 'CFOSWaco'
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.spelloptions = 'camel'
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.swapfile = false
vim.o.switchbuf = 'usetab,uselast'
vim.o.tabstop = 2
vim.o.timeoutlen = 300
vim.o.undodir = vim.fn.stdpath 'state' .. '/undo'
vim.o.viewdir = vim.fn.stdpath 'state' .. '/view'
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.virtualedit = 'block'
vim.o.winborder = 'single'
vim.o.wrap = false
vim.opt.listchars = { tab = '> ', trail = '-', nbsp = '+' }

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd 'filetype plugin indent on'
if vim.fn.exists 'syntax_on' ~= 1 then vim.cmd 'syntax enable' end

require 'autocmd'
require 'keymaps'
require 'lsp'
require 'plugins'

vim.cmd.colorscheme 'miniautumn'

-- vim: ts=2 sts=2 sw=2 et
