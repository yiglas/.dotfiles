-- This file is automatically loaded by plugins.core
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.g.autoformat = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = false
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.showmode = false
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 0
vim.opt.concealcursor = ''
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 300

vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.opt.ruler = false

vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = 'indent,eol,start'
vim.opt.autochdir = false
vim.opt.iskeyword:append('-')
vim.opt.path:append('**')
vim.opt.selection = 'exclusive'
vim.opt.mouse = 'a'
vim.opt.encoding = 'UTF-8'
vim.opt.fillchars:append({ eob = ' ' })

vim.opt.foldmethod = 'expr'
-- vim.wo.vim.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = 'unnamedplus'

return {}
