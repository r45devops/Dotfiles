-- 设置选项
vim.opt.runtimepath:prepend('~/.config/nvim')
vim.opt.runtimepath:append('~/.config/nvim/after')
-- 基础设置
vim.opt.guicursor = "a:block"
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME') .. '/.config/nvim/undodir' -- 撤销文件目录
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.cursorline = true
